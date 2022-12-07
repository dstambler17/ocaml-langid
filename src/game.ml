[@@@ocaml.warning "-33"]
[@@@ocaml.warning "-27"]

open Core
module M = Models

let examples = [("hello", "en"), ("Hola mi amigo", "es")]

(*
Get an example and its ground truth from preloaded examples
*)
let pick_targets (ex_gt : (string * string) list) : (string * string) = 
  let idx = examples |> List.length |> Random.int in
  List.nth_exn ex_gt idx

(*
Define list of answers for the game setting. Given a groundtruth and all possible languages, 
output a list of languages containing groundtruth, paired with a bool whether it is the correct answer
*)
let game_choices (gt : string) (langs: string list) : (string * bool) list = 
  failwith "unimplemented"

(*
Score user guess vs model output  
bools are outputs of check player and model response functions
1 if user wins, 0.5 if tie, 0 if user 
*)
let evaluate_example (user_correct: bool) (model_correct: bool) : float = 
  match model_correct, user_correct with
  | true, true -> 0.5
  | false, true -> 1.
  | _, false -> 0.

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
  failwith "unimplemented"
(*
Pick winner based on scores at the end of the game   
*)
let evaluate_winner (user_score : int) (model_score : int) : bool = 
  failwith "unimplemented"
