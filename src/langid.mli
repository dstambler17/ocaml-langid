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
$ ./langid.exe [--mode ['game', 'eval']] [--model-path MODEL_PATH] [--top_n TOP_N (default = 1)] [--filename FILENAME] [--input [sentences_list]] 

GAME CASE
$ ./langid.exe --mode game 
Welcome to LangID! Can you beat me? I'll give you some text and some language choices. You'll get a point when you get it right, and a bonus if you get it right and I don't. Let's play. 
>> Hola mi amigo!
(1) Spanish (2) Chinese (3) Hebrew
<< 1
You got it! It was Spanish! So did I, though. 1 point for you, 1 for me. 
>> 

EVAL CASE
$ ./langid.exe --filename FILENAME [--model-path MODEL_PATH] --mode eval' --top_n 3
The top 3 options for FILENAME are (Spanish, 82\%), (Portugese, 16\%), ()

$ ./langid.exe    
*)
