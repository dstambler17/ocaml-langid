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
