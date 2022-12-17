open Utils
(*
    The Sampler Class will be used to
    source sentences from a give webpage
    Sentences will be randomly selected from each article
*)

(*
   Clean all HTML and meta data. Return only text
*)
val strip_html: string -> string

(*
    Use OCaml http lib to get html body of webpage
*)
val get_html_body: string -> string

(*
    Sample Random Sentence given a url and call
    the above functions
    Params: url, Random module
*)
val sample_sentence: string -> (module Randomness) -> string 