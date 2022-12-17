[@@@ocaml.warning "-33"]
[@@@ocaml.warning "-27"]
[@@@ocaml.warning "-32"]

open Owl
open Core
open Utils

module O = Owl_dense_ndarray_s
module U = Owl_utils_array

type arr = O.arr

let unimplemented () =
	failwith "unimplemented"

let invalid_class_file () =
  failwith "Invalid class file. Should never get here unless the model files were changed or tampered with"

(* Define Consts *)
let num_features () =
  7480

let num_classes () =
  97

(*Helper function, load json string to a map, then converts to json *)
let load_json_string (str: string): Yojson.Basic.t =
  Yojson.Basic.from_file str

(* The following five functions deal with loading all model/class info *)

(*Loads lang id classes into list, but first Load class into json obj. *)
let load_classes (file_path: string): string list =
  let open Yojson.Basic.Util in
  let json_item  =  load_json_string file_path in
  json_item |> member "classes" |> to_list |> filter_string

(* Loads Finite State Transducer Model List called 'tk_nextmove' *)
let load_fst_list (file_path: string): int list =
  let open Yojson.Basic.Util in
  let json_item  =  load_json_string file_path in
  json_item |> member "tk_nextmove" |> to_list |> filter_int

(*Loads Finite State Transducer Model Map  tk_output*)
let load_fst_map (file_path: string): (int, int list, 'a) Map.t =
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

(* 
   Get a map of states and counts from input text. States come from
   this formula: state = tk_nextmove[(state << 8) + letter]  
   Where tk_nextmove is an array representation of some Finite State Machine
*)
  unimplemented()

let get_state_count_map (input_str: string) (tk_nextmove: int list): (int, int, 'a) Map.t  =
  let state_count = Map.empty (module Int) in
  let state_map, _ = input_str |> String.fold 
    ~f:(fun (state_count_map, state) letter ->
        let state_look_up = (Int.shift_left state 8) + int_of_char letter (*(CamomileLibrary.UChar.int_of (CamomileLibrary.UChar.of_char letter) )*) in
        
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
  state_map

(* Get a tuple list of indicies to update in feature vec and value to set these indicies to *)
let get_index_count_list (state_map) (tk_output: (int, int list, 'a) Map.t ): (int * int) list =
  (Map.keys state_map) |> List.fold
      ~f:(fun idx_list state -> 
        let index_sub_list = match (Map.find tk_output state) with
          | Some(list_item) -> list_item
          | None -> []
        in
        let tuple_list = index_sub_list |> List.map
          ~f:(fun cur_index -> 
            let cur_val_count = match (Map.find state_map state) with
              | Some(v) -> v
              | None -> 0
            in
            (cur_index, cur_val_count))
        in
        List.unordered_append idx_list tuple_list 
      )
      ~init:([])


let instance2fv (input_str: string) (tk_nextmove: int list) (tk_output: (int, int list, 'a) Map.t ): arr  = 
  (* Init the feature vector to be an Owl array of zeros *)  
  let feature_vec = O.zeros (List.to_array [1; num_features ()]) in
  
  (* Get all states and number of times states were hit *)
  let state_map = get_state_count_map input_str tk_nextmove in
  
  (*Get list of indicies to update and values to set indicies to *)
  let index_count_tuple_list = get_index_count_list state_map tk_output in

  (* Update the feature vector indicies. NOTE: mutation is needed here *)    
  let _ = index_count_tuple_list |> List.iter 
      ~f:(fun (idx, count_val) -> 
        let cur_val = O.get feature_vec (List.to_array [0; idx]) in
        let _ = O.set feature_vec (List.to_array [0; idx]) (cur_val +. float_of_int count_val) in
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

let run_model (input_text: string) : arr =
  (*load in all models, FSTs, and files*)
  let tk_nextmove = load_fst_list  "models/fst_feature_model_info.json" in
  let tk_output = load_fst_map  "models/fst_feature_model_info.json" in
  let hidden_weights =  load_model_file "models/nb_ptc.npy" in
  let hidden_bias = load_model_file "models/nb_pc.npy" in

  (* convert text input to feature vector *)
  let feature_vec  = instance2fv input_text tk_nextmove tk_output in
  nb_classprobs feature_vec hidden_weights hidden_bias

let classify (input_text: string): (float * string) list =
  let classes = load_classes "models/classes_info.json" in
  let model_output = run_model input_text in
  [pick_highest_score model_output classes]

(* TODO: Implement later *)
let norm_probs (inp: arr): arr =
  O.softmax inp

let rank (inp: (string * float) list): (string * float) list =
  unimplemented()

(*Note added this to resolve merge*)
let top_choices (input_text: string) (k_choices: int): (string * float) list = 
  unimplemented()
(* let top_choices (input_text: string) (k_choices: int): (string * float) list = 
  input_text
  |> run_model
  |> O.tolist
  |> List.zip (load_classes "models/classes_info.json")
  |> rank
  |> List.filteri ~f:(fun i _ -> if i < k_choices then true else false) *)

