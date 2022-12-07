[@@@ocaml.warning "-33"]

open Owl
(*open Torch *)

(*BELOW ARE THE MLI DECLARATIONS SPECIFIC FOR THE LANG ID LIBRARY*)

(* 
Load model file from path, get back a string representation of the model
*)
type arr =
  (float, Stdlib.Bigarray.float32_elt, Stdlib.Bigarray.c_layout )
   Stdlib.Bigarray.Genarray.t

val load_model_file: string -> arr

(* 
Load torch model from weights. Given a string, return the ocaml torch representation of a model  
*)
(*val load_model_weights: string -> Model.t*)

(* 
Given an input string and a model, call the UTF-8 encoder, and pass it through the model
Return a probability distribution over
all possible lang id types
The results will look something like this:

Input String: "I am an example"
Output: [(0.7, 'en'); (0.15, 'fr'), (.1, 'cn') ...]
*)
(*val classify: string -> Model.t -> (float * string) list*)

(*
Given the model predictions, sort the model predictions according
to the likelihood that the string is written in each language.
*)
(*TODO: UNCOMMENT WHEN DONE*)
(*val rank: (string * float) list -> (string * float) list

(*
Map an instance into the feature space of the trained model.
*)
val instance2fv: string -> Model.t -> 'a list

(*
Given input sentence, model, and top_N, output model likelihoods
and return the top n results
Calls the rank and classify methods   
*)
val top_choices: string -> Model.t -> int -> (string * float) list
*)