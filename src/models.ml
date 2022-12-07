[@@@ocaml.warning "-33"]

open Owl
open Core
open Utils
(*open Torch *)

[@@@ocaml.warning "-27"]
[@@@ocaml.warning "-32"]

type arr =
  (float, Stdlib.Bigarray.float32_elt, Stdlib.Bigarray.c_layout )
   Stdlib.Bigarray.Genarray.t


let unimplemented () =
	failwith "unimplemented"


(*let m = Map.empty (module String)*) 

(*Loads lang id classes into list*)
let load_classes (file_path: string): string list =
  (* Load class into json obj*)
  let json_item  =  load_json_string file_path in
  let classes = json |> member "classes" |> to_list |> filter_string in
  classes

(*Loads Finite State Transducer Model*)
let load_fst (str: Yojson.Basic.t): string list =
  (*let json_item  =  load_json_string file_path in*)
  unimplemented ()
(*TODO: IMPLEMENT*)


let load_model_file (path: string): arr =
  Owl_dense_ndarray_s.load_npy path

(*let load_model_weights: (model_state_dict :string): 'a Torch_core.Wrapper.Module =
  unimplemented () *)
  
(*let classify: (input_text :string) (model: 'a Torch_core.Wrapper.Module): (float * string) list =
  unimplemented ()*)
