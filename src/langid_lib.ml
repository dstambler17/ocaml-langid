[@@@ocaml.warning "-33"]

open Core
open Owl

let unimplemented () =
	failwith "unimplemented"

let load_model_file (path: string): string = 
  unimplemented ()

let load_model_weights: (model_state_dict : string) : string = 
  unimplemented ()

let classify: (input_text :string) (model: 'a Torch_core.Wrapper.Module): (float * string) list =
  unimplemented ()

let rank: (preds : (string * float) list) : (string * float) list =
  unimplemented ()

let instance2fv: (instance: string) (str: string) : 'a list =
  unimplemented ()

let top_choices: (sentence : string) (model : string) (top_n : int) : (string * float) list =
  unimplemented ()