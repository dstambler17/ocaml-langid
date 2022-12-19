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
   Builds the URL given a lang code string
   Randomly Samples from a hardcoded list of topics
   And creates a url to a wikipedia article in the given language
*)
val build_url: string -> (module Randomness) -> string option

(*
    Sample Random Bag of k chars given a Language ID string
    Build the URL and call
    the above functions to get the full text
    Then Sample a random k chars. If k exceeds the size of the article, return the whole article
        Params: url, Random module
*)
val sample_text: string -> int -> (module Randomness) -> string option


(* val get_translated: string -> string -> string *)