[@@@ocaml.warning "-33"]
[@@@ocaml.warning "-27"]
[@@@ocaml.warning "-32"]

open Owl
open Core
open Utils



type arr =
  (float, Stdlib.Bigarray.float32_elt, Stdlib.Bigarray.c_layout )
   Stdlib.Bigarray.Genarray.t


let unimplemented () =
	failwith "unimplemented"


(*Helper function, load json string to a map, then converts to*)
let load_json_string (str: string): Yojson.Basic.t =
  Yojson.Basic.from_file str

(* The following five functions deal with loading all model/class info *)

(*Loads lang id classes into list *)
let load_classes (file_path: string): string list =
  (* Load class into json obj*)
  let open Yojson.Basic.Util in
  let json_item  =  load_json_string file_path in
  json_item |> member "classes" |> to_list |> filter_string

(* Loads Finite State Transducer Model List called tk_nextmove*)
let load_fst_list (file_path: string): int list =
  let open Yojson.Basic.Util in
  let json_item  =  load_json_string file_path in
  json_item |> member "tk_nextmove" |> to_list |> filter_int


(*Loads Finite State Transducer Model Map  tk_output*)
(*TODO: Add type to return once we set up functor stuff*)
let load_fst_map (file_path: string) =
  let create_map_helper (input_list: (int * int list) list) =
    let m = Map.empty (module Int) in
    input_list |> List.fold 
        ~f:(fun acc (k, v) -> Map.add_exn acc ~key:k ~data:v) (*NOTE: Exception should not occur, TODO: Double check*)
        ~init:(m)
  in
  
  let open Yojson.Basic.Util in
  let json_item  =  load_json_string file_path in
  json_item 
    |> member "tk_output"
    |> to_assoc
    |> List.map ~f:(fun (k, v) -> (int_of_string k), v |> to_list |> filter_int)  
    |> create_map_helper
  
  
(* Loads .npy (numpy model) files *)
let load_model_file (path: string): arr =
  Owl_dense_ndarray_s.load_npy path

let instance2fv (input: string) (tk_nextmove: int list) (tk_output): arr  = 
  (*TODO: Add consts file to replace magic nums*)
  (*TODO: fill out function logic from langid. This uses bitshifts *)
  (* Replace with zeros *)
  let feature_vec = Owl_dense_ndarray_s.ones (List.to_array [1; 7480])


let nb_classprobs (fv: arr) (hidden: arr) (bias: arr): arr =
  let hidden_out = Owl_dense_ndarray_s.dot fv hidden in 
  Owl_dense_ndarray_s.add bias

let pick_highest_score (inp: arr) (classes: string list): (string * float) =
  (* Helper function that returns highest scoring index*)
  let argmax (inp: arr): int =
    score, max_arr = Owl_dense_ndarray_s.max_i inp;;
    let max_idx = match (Array.to_list max_arr) with
      | _, res -> res
    in
    score, max_idx
  in

  let score, max_idx = argmax inp in
  let langcode_opt = classes |> List.findi ~f:(fun idx -> idx == max_idx) in
  let langcode = 
    match langcode_opt with 
    | Some(_, code) -> code 
    | None -> failwith
  in
  
  
let classify (input_text: string): (float * string) list =
  unimplemented()

(* TODO: Implement later *)
let norm_probs (inp: arr): arr =
  unimplemented()

let rank (inp: (string * float) list): (string * float) list =
  unimplemented()

let top_choices (inp: string) (k_choices: int): (string * float) list = 
  unimplemented()
