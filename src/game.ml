[@@@ocaml.warning "-33"]
[@@@ocaml.warning "-27"]

open Core
module M = Models

(*
Get an example and its ground truth from preloaded examples
*)
let pick_targets (ex_gt : (string * string) list) : (string * string) = 
  ex_gt 
  |> List.length 
  |> Random.int 
  |> List.nth_exn ex_gt

(* 
add a random sorting bit to each index, sort by those, and return first n values 
*)
let shuffle_and_pick_n (l : 'a list) (n : int) : 'a list =
  l 
  |> List.map ~f:(fun x -> (Random.bits (), x))
  |> List.sort ~compare:(fun (b1, x1) (b2, x2) -> compare b1 b2)
  |> List.map ~f:(fun (_, x) -> x)
  |> List.filteri ~f:(fun i _ -> if i < n then true else false)

(*
Define list of answers for the game setting. Given a groundtruth and all possible languages, 
output a list of languages containing groundtruth, paired with a bool whether it is the correct answer
*)
let game_choices (gt : string) (langs: string list) (num_choices : int): (string * bool) list = 
  let other_langs = langs 
  |> List.filter ~f:(fun x -> if String.(=) gt x then false else true)
  |> Fn.flip shuffle_and_pick_n num_choices in 
  shuffle_and_pick_n (gt :: other_langs) (1 + num_choices)
  |> List.map ~f:(fun x -> (x, if String.(=) x gt then true else false))
  
(*
Score user guess vs model output  
bools are outputs of check player and model response functions
1 if user wins, 0.5 if tie, 0 if user 
*)
let evaluate_example (user_correct: bool) (model_correct: bool) : float = 
  match user_correct, model_correct with
  | true, true -> 0.5
  | true, false -> 1.
  | false, true -> 2.
  | false, false -> 0.

(*
Check if the player guessed correctly or not   
*)
let check_player_response (input_idx : int) (possible_choices : (string * bool) list) : bool = 
  input_idx |> List.nth_exn possible_choices |> Tuple2.get2
  
(*
given model guess and groundtruth, check if model guessed correctly
*)
let check_model_response (model_output : string) (possible_choices : (string * bool) list) : bool = 
  List.filter possible_choices ~f:(fun (_, correct) -> if correct then true else false)
  |> List.hd_exn
  |> Tuple2.get1
  |> String.(=) model_output

(*
Generate output based on recent event
takes user and model correctness, as well as groundtruth, and returns a string to 
communicate with user   
*)
let event_string (user_correct : bool) (model_correct : bool) (gt: string) : string = 
  match user_correct, model_correct with
  | true, true -> Printf.sprintf "You were correct, as was I! It was indeed %s\n" gt
  | true, false -> "Ah! You got me on this one. I'll get you next time...\n"
  | false, true -> Printf.sprintf "Ha! One for me, none for you! The actual answer was %s\n" gt
  | false, false -> Printf.sprintf "Seems we're both bad at this - no points for either of us. The actual answer was %s\n" gt
  
(*
Pick winner based on scores at the end of the game   
*)
let winner_string (user_score : int) (model_score : int) : string = 
  match compare user_score model_score with
  | -1 -> "Ha-Ha, I win! AI will rule the world!"
  | 0 -> "Great game, that was a hard-fought tie. Maybe we should play again to settle the score..."
  | 1 -> Printf.sprintf "You beat me %d-%d! Are you sure you're not a computer? Good game." user_score model_score
  | _ -> failwith "I guess no one wins"
