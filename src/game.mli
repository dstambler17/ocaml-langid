(*BELOW ARE THE MLI DECLARATIONS SPECIFIC FOR THE COMMAND LINE GAME*)
(* open Core *)

(*
    Given a list of target language codes, randomly pick
    the ground truth language code then call the sampler
    to Get a random sentence in that given languges
    Returns (SAMPLE, LANG_CODE)
*)
val pick_targets: string list -> (string * string)

(*
Define list of answers for the game setting. Given a groundtruth and all possible languages, 
output a list of languages containing groundtruth, paired with a bool whether it is the correct answer
*)
val game_choices: string -> string list -> int -> (string * bool) list

(* 
Given a ground truth list, make a string to print for user options
*)
val user_option_string: (string * bool) list -> string

(* 
Get user input from the command line
*)
val get_user_input: int

(*
Score user guess vs model output  
bools are outputs of check player and model response functions
1 if user wins, 0.5 if tie, 0 if user 
*)
val evaluate_example: bool -> bool -> (int * int)

(*
Check if the player guessed correctly or not   
*)
val check_player_response: int -> (string * bool) list -> bool

(*
given model guess and groundtruth, check if model guessed correctly
*)
val check_model_response: string -> (string * bool) list -> bool

(*
Generate output based on recent event
takes user and model correctness, as well as groundtruth, and returns a string to 
communicate with user   
*)
val event_string: bool -> bool -> string -> string

(*
Pick winner based on scores at the end of the game   
*)
val winner_string: int -> int -> string 

(* 
OVERALL USAGE EXAMPLE
########################################################################
Parameters: 
-mode: Setting the use case mode to game or eval
-top_n: Number of predicted languages to output, defaults to 1
-filename: path of a file to use as input for the model
-input: raw sentence input for running the model, sentences are separated by period
$ ./langid.exe [-mode ['game', 'eval']] [-top_n TOP_N (default = 1)] [-filename FILENAME] [-input [sentences_list]] 

GAME CASE
########################################################################
$ ./langid.exe -mode game 
Welcome to LangID! Can you beat me? I'll give you some text and some language choices. 
You'll get a point when you get it right, and a bonus if you get it right and I don't. 
Enter STOP to end the game. Let's play!
>> Hola mi amigo
(1) Spanish (2) Chinese (3) Hebrew
<< 1
You got it! It was Spanish! So did I, though. 1 point for you, 1 for me. 
>> le temps est agréable
(1) Armenian (2) Portugese (3) French
<< 2
Too bad, it was French! That's a point for me. 2-1
>> vejret er dejligt
(1) Danish (2) German (3) Finnish
<< 3
It was actually Danish. I didn't get it either. 2-1
>> d'Wieder ass schéin
(1) Luxembourgish (2) Russian (3) German
<< STOP
Good game! We went over 3 examples, and you got 1 of them. I won 2-1. It's tough to beat a computer!

EVAL CASE
########################################################################
$ ./langid.exe -filename inferno.txt -mode eval -top_n 3
The top 3 options for inferno.txt are (Italian, 82%), (Portugese, 16%), (Spanish, 2%)

$ ./langid.exe -filename don_quixote.txt -mode eval
The top 3 options for don_quixote.txt are (Spanish, 96%)

$ ./langid.exe -mode eval -top_n 3 -input como estas . le temps est agréable
Sentence 1: (Spanish, 90%), (Portugese, 7%), (French, 3%)
Sentence 2: (French, 90%), (Italian, 7%), (Latin, 3%)
*)
