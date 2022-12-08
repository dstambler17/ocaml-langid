[@@@ocaml.warning "-33"]

open Owl
(*open Torch *)

(* 
Load model file from path, get back a string representation of the model
*)
type arr =
  (float, Stdlib.Bigarray.float32_elt, Stdlib.Bigarray.c_layout )
   Stdlib.Bigarray.Genarray.t

(* 
   Convert text input to a feature vector 
   Ex input : "Hi, my name is Jack"
   Ex: output: Owl (numpy) arr item
*)
(*TODO: Figure out typing via functors then uncomment*)
(*val instance2fv: string -> int list -> Map.t -> arr*)

(*
   Passes the feature vector through the model
   Inputs: feature vector
           model weights
           model bias
   Outputs: raw prediction matrix
*)
val nb_classprobs: arr -> arr -> arr -> arr

(* Return softmax to turn feature vector into probability disttribution*)
val norm_probs: arr -> arr

(* Return highest score from the output vector and pick idx from string list *)
val pick_highest_score: arr -> string list -> (string * float)

(*
  Primary function 
  Given an input string and a model, call the UTF-8 encoder, and pass it through the model
  Return a probability distribution over
  all possible lang id types
  The results will look something like this:

  Input String: "I am an example"
  Output: [(0.7, 'en'); (0.15, 'fr'), (.1, 'cn') ...]
*)
val classify: string -> (float * string) list

(*
  Given the model predictions, sort the model predictions according
  to the likelihood that the string is written in each language.
*)
val rank: (string * float) list -> (string * float) list

(*
  Given input sentence, model, and top_N, output model likelihoods
  and return the top n results
  Calls the rank and classify methods   
*)
val top_choices: string -> int -> (string * float) list
