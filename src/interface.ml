[@@@ocaml.warning "-33"]

Open Owl
Open Core

module ID = Langid

let unimplemented () =
  failwith "unimplemented"

(*
Get an example and its ground truth from preloaded examples
*)
let pick_targets (ex_gt : (string * string) list) : (string * string) = 
  unimplemented ()

(*
Define list of answers for the game setting. Given a groundtruth and all possible languages, 
output a list of languages containing groundtruth, paired with a bool whether it is the correct answer
*)
let game_choices (gt : string)(langs: string list) : (string * bool) list = 
  unimplemented ()

(*
Score user guess vs model output  
bools are outputs of check player and model response functions
1 if user wins, 0.5 if tie, 0 if user 
*)
let evaluate_example: (user: bool) (model: bool) -> float = 
  unimplemented ()

(*
Check if the player guessed correctly or not   
*)
let check_player_response: (input_idx : int) (possible_choices : (string * bool) list) : bool = 
  unimplemented ()

(*
given model guess and groundtruth, check if model guessed correctly
*)
let check_model_response: (model_output : string) (possible_choices (string * bool) list) : bool = 
  unimplemented ()

(*
Generate output based on recent event
takes user and model correctness, as well as groundtruth, and returns a string to 
communicate with user   
*)
let event_string: (user_correct : bool) (model_correct : bool) (gt: string) : string = 
  unimplemented ()

(*
Pick winner based on scores at the end of the game   
*)
let evaluate_winner: (user_score : int) (model_score = int) : bool = 
  unimplemented ()

