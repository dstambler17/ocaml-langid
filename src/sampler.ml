[@@@ocaml.warning "-27"]
[@@@ocaml.warning "-33"]

open Core
open Str
open Utils
open Lwt
open Cohttp
open Cohttp_lwt_unix

(* Declare Consts *)
let get_url (lang_code: string) (topic: string): string =
  "https://"^lang_code^".wikipedia.org/wiki/"^topic

(* Helper function to return list of strings *)
let topic_list (): string list =
  [
    "Blackbeard"; "OpenAI"
  ]

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


let build_url (lang_code: string) (module R: Randomness): string option =
  match list_sample_helper (topic_list ()) (module R) with
  | None -> None
  | Some(topic) -> Some(get_url lang_code topic)

let sample_text (lang_code: string) (sample_len: int) (module R: Randomness): string option =
  let url_opt = build_url lang_code (module R) in
  match url_opt with
  | None -> None
  | Some(url) -> 
    let text_doc = url |> get_html_body |> strip_html in
    if (String.length text_doc) <= sample_len then
      Some(text_doc)
    else
      let l_idx = R.int ((String.length text_doc) - sample_len) in
      let r_idx = l_idx + sample_len in
      Some(String.slice text_doc l_idx r_idx)
  