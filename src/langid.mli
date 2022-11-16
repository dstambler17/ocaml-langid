[@@@ocaml.warning "-33"]

open Torch
(* 
Load model file from path, get back a string representation of the model
*)
val load_model_file: string -> string

(* 
Load torch model from weights    
*)
val load_model_weights: string -> Model

(* 
Given an input string and a model, classify the model
*)
val classify: string -> Model.t -> (float * string) list

set_languages

rank

"""
Map an instance into the feature space of the trained model.
"""
instance2fv

(* 
OVERALL USAGE
########################################################################
Parameters: 
--mode: Setting the use case mode to game or eval
--model-path: Specify a pretrained model other than the one native to our application
--top_n: Number of predicted languages to output, defaults to 1
--filename: path of a file to use as input for the model
--input: raw sentence input for running the model, sentences are separated by period
$ ./langid.exe [--mode ['game', 'eval']] [--model-path MODEL_PATH] [--top_n TOP_N (default = 1)] [--filename FILENAME] [--input [sentences_list]] 

GAME CASE
########################################################################
$ ./langid.exe --mode game 
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
$ ./langid.exe --filename inferno.txt --mode eval --top_n 3
The top 3 options for inferno.txt are (Italian, 82%), (Portugese, 16%), (Spanish, 2%)

$ ./langid.exe --filename don_quixote.txt --mode eval
The top 3 options for don_quixote.txt are (Spanish, 96%)

$ ./langid.exe --filename inferno.txt --model-path ../models/langid/really_bad_model.pt --mode eval --top_n 3
The top 3 options for inferno.txt are (Russian, 82%), (German, 16%), (Italian, 2%)

$ ./langid.exe --mode eval --top_n 3 --input como estas . le temps est agréable
Sentence 1: (Spanish, 90%), (Portugese, 7%), (French, 3%)
Sentence 2: (French, 90%), (Italian, 7%), (Latin, 3%)
*)
