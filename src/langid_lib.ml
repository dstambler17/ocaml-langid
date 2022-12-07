[@@@ocaml.warning "-27"]

open Core
(* open Owl *)


let load_model_file (path : string) : string = 
  failwith "unimplemented"

let load_model_weights (model_state_dict : string) : string = 
  failwith "unimplemented"

let classify (input_text : string) (model : string) : (float * string) list =
  failwith "unimplemented"

let rank (preds : (string * float) list) : (string * float) list =
  failwith "unimplemented"

let instance2fv (instance: string) (str: string) : 'a list =
  failwith "unimplemented"
  
let top_choices (sentence : string) (model : string) (top_n : int) : (string * float) list =
  failwith "unimplemented"