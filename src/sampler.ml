[@@@ocaml.warning "-27"]
[@@@ocaml.warning "-33"]

open Core
open Str
open Utils
open Lwt
open Cohttp
open Cohttp_lwt_unix

(* From Cohttp Docs, helper function for making requests *)
let get_body_helper url_str=
  Client.get (Uri.of_string url_str) 
    >>= fun (resp, body) ->  
      let _ = resp 
        |> Response.status 
        |> Code.code_of_status in  
        body |> Cohttp_lwt.Body.to_string >|= fun body -> 
        body

let get_html_body (url: string): string =
  Lwt_main.run (get_body_helper url)


let strip_html (raw_input: string): string =
  (* Define regex for extracting relevant text from raw HTML *)
  let newline_strip_re = regexp "\n" in
  let tab_strip_re = regexp "\t" in
  let arrow_re = regexp "-->" in
  let unicode_re = regexp "&#[0-9A-Fa-f]+;" in
  let head_re = regexp "<\\(head\\).*?>.*?</\\(head\\)>" in
  let nav_re = regexp "<\\(nav\\).*?>.*?</\\(nav\\)>" in
  let footer_re = regexp "<\\(footer\\).*?>.*?</\\(footer\\)>" in
  let script_re = regexp "<\\(script\\).*?>.*?</\\(script\\)>" in
  let table_re =  regexp "<\\(table\\).*?>.*?</\\(table\\)>" in
  let tag_re = regexp "<[^>]*>" in
  let space_re = regexp "\\( \\)+" in (* replace multispaces with 1 space *)

  raw_input
    |> global_replace newline_strip_re " "
    |> global_replace head_re " "
    |> global_replace nav_re " "
    |> global_replace footer_re " "
    |> global_replace script_re " "
    |> global_replace table_re " "
    |> global_replace tag_re " "
    |> global_replace tab_strip_re " "
    |> global_replace arrow_re " "
    |> global_replace unicode_re " "
    |> global_replace space_re " "

let sample_sentence (url: string) (module R: Randomness): string option =
  let sentence_bag = url |> get_html_body |> strip_html |> String.split ~on:'.' in
  list_sample_helper sentence_bag (module R)
  