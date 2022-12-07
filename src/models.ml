[@@@ocaml.warning "-33"]

open Owl
open Core
(*open Torch *)

[@@@ocaml.warning "-27"]
[@@@ocaml.warning "-32"]

type arr =
  (float, Stdlib.Bigarray.float32_elt, Stdlib.Bigarray.c_layout )
   Stdlib.Bigarray.Genarray.t


let unimplemented () =
	failwith "unimplemented"

(*TODO: Not needed, delete*)
let read_file_input (file_path: string): string list =
  let file = In_channel.create file_path in
  let strings = In_channel.input_lines file in
  In_channel.close file;
  strings

(*let m = Map.empty (module String)*) 

(*Load json string to a map, then converts to*)
let load_json_string (str: string): Yojson.Basic.t =
  let json2 = Yojson.Basic.from_file str in
  json2

(*Loads classes *)
(*let load_classes (str: Yojson.Basic.t): =*)


let load_model_file (path: string): arr =
  Owl_dense_ndarray_s.load_npy path

(*let load_model_weights: (model_state_dict :string): 'a Torch_core.Wrapper.Module =
  unimplemented () *)
  
(*let classify: (input_text :string) (model: 'a Torch_core.Wrapper.Module): (float * string) list =
  unimplemented ()*)
