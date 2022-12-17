[@@@ocaml.warning "-33"]
[@@@ocaml.warning "-27"]
[@@@ocaml.warning "-32"]

open Owl
open Core
open Utils

module O = Owl_dense_ndarray_s


type arr = O.arr
(*type arr =
  (float, Stdlib.Bigarray.float32_elt, Stdlib.Bigarray.c_layout )
   Stdlib.Bigarray.Genarray.t*)


let unimplemented () =
	failwith "unimplemented"

let invalid_class_file () =
  failwith "Out of bounds class file. Should never get here unless you switched out the files"
  

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
  O.load_npy path

let instance2fv (input_str: string) (tk_nextmove: int list) (tk_output): arr  = 
  (*TODO: Add consts file to replace magic nums*)
  (*TODO: Need to encode special char to utf8 for this to work*)
  (*TODO: Double check this or mat mul funcs for bug causing every prediction to be de *)

  let feature_vec = O.zeros (List.to_array [1; 7480]) in
  let state_count = Map.empty (module Int) in
  let state_map, _ = input_str |> String.fold 
    ~f:(fun (state_count_map, state) letter ->
        let state_look_up = (Int.shift_left state 8) + (CamomileLibrary.UChar.int_of (CamomileLibrary.UChar.of_char letter) ) in
        
        let cur_state_opt = tk_nextmove |> List.findi ~f:(fun idx _ -> idx = state_look_up) in
        
        let cur_state = 
          match cur_state_opt with 
          | Some(_, num) -> num 
          | None -> invalid_class_file() (*should not get here*)
        in

        let cur_count = match Map.find state_count_map cur_state with
          | Some(v) -> v 
          | None -> 0
        in
       (Map.set state_count_map ~key:cur_state ~data:(cur_count + 1)), cur_state
      )
    ~init:(state_count, 0)
  in
  (*Now update the feature vector from the compiled state info*)
  (*This returns unit*)
  let state_map_two = state_map in
  
  (*Get list of indicies to update*)
  let index_count_tuple_list = (Map.keys state_map) |> List.fold
      ~f:(fun idx_list state -> 
        let index_sub_list = match (Map.find tk_output state) with
          | Some(list_item) -> list_item
          | None -> []
        in
        let tuple_list = index_sub_list |> List.map
          ~f:(fun cur_index -> 
            let cur_val_count = match (Map.find state_map_two state) with
              | Some(v) -> v
              | None -> 0
            in
            (cur_index, cur_val_count))
        in
        tuple_list @ idx_list (* TODO: MAYBE REPLACE LATER *)
      )
      ~init:([])
  in

  (* Update the right feature vector indicies *)    
  let _ = index_count_tuple_list |> List.iter 
      ~f:(fun (idx, count_val) -> 
        let cur_val = Owl_dense_ndarray_s.get feature_vec (List.to_array [0; idx]) in
        let _ = Owl_dense_ndarray_s.set feature_vec (List.to_array [0; idx]) (cur_val +. float_of_int count_val) in
        ()
      )
  in
  feature_vec


let nb_classprobs (fv: arr) (hidden: arr) (bias: arr): arr =
  let hidden_out = O.dot fv hidden in 
  O.add hidden_out bias 

let pick_highest_score (inp: arr) (classes: string list): (float * string) =
  (* Helper function that returns highest scoring index*)
  let argmax (inp: arr): (float * int) =
    let score, max_arr = O.max_i inp in
    let max_idx = match (Array.to_list max_arr) with
      | _::res::[] -> res
      | _ -> failwith "Should not be reached"
    in
    score, max_idx
  in

  let score, max_idx = argmax inp in
  let langcode_opt = classes |> List.findi ~f:(fun idx _ -> idx = max_idx) in
  let langcode = 
    match langcode_opt with 
    | Some(_, code) -> code 
    | None -> invalid_class_file()
  in
  score, langcode
  
let classify (input_text: string): (float * string) list =
  (*First load in all models, FSTs, and files*)
  let classes = load_classes "models/classes_info.json" in
  let tk_nextmove = load_fst_list  "models/fst_feature_model_info.json" in
  let tk_output = load_fst_map  "models/fst_feature_model_info.json" in
  let hidden_weights =  load_model_file "models/nb_ptc.npy" in
  let hidden_bias = load_model_file "models/nb_pc.npy" in

  (* convert text input to feature vector *)
  let feature_vec  = instance2fv input_text tk_nextmove tk_output in
  let model_outs = nb_classprobs feature_vec hidden_weights hidden_bias in

  (*return a list as we will later support top k results*)
  [pick_highest_score model_outs classes]

(* TODO: Implement later *)
let norm_probs (inp: arr): arr =
  O.softmax inp

let rank (inp: (string * float) list): (string * float) list =
  unimplemented()

let top_choices (inp: string) (k_choices: int): (string * float) list = 
  unimplemented()
