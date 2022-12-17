[@@@ocaml.warning "-27"]
[@@@ocaml.warning "-33"]

open Core
open Str
open Utils
open Lwt
open Cohttp
open Cohttp_lwt_unix

let unimplemented () =
	failwith "unimplemented"

(* From Cohttp Docs, helper function for making requests *)
let get_body_helper url_str=
  Client.get (Uri.of_string url_str) 
    >>= fun (resp, body) ->  
      let code = resp 
        |> Response.status 
        |> Code.code_of_status in  
        Printf.printf "Response code: %d\n" code;
        Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
        body |> Cohttp_lwt.Body.to_string >|= fun body -> 
        Printf.printf "Body of length: %d\n" (String.length body);
        body

let get_html_body (url: string): string =
  Lwt_main.run (get_body_helper url)

let strip_html (raw_input: string): string =
  unimplemented ()

let sample_sentence (url: string) (module R: Randomness): string =
  unimplemented ()
