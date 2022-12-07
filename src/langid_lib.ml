[@@@ocaml.warning "-33"]

open Core
open Torch

[@@@ocaml.warning "-27"]

let unimplemented () =
	failwith "unimplemented"

let load_model_file (path: string): string =
  unimplemented ()
let load_model_weights: (model_state_dict :string): 'a Torch_core.Wrapper.Module =
  unimplemented ()
let classify: (input_text :string) (model: 'a Torch_core.Wrapper.Module): (float * string) list =
  unimplemented ()
