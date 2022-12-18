[@@@ocaml.warning "-33"]
[@@@ocaml.warning "-32"]
[@@@ocaml.warning "-26"]

open Core
open Printf
open Stdio
module M = Models
module G = Game
module CLI = Minicli.CLI

let help_print =
  "\n\
   Example usage:\n\
   \t./langid.exe -mode <string> -top_n <int> -input <string> [-h;-help]\n\n\
   Arguments:\n\
   \t-mode:\n\
   \t\tgame - Play a langid guessing game against the model\n\
   \t\teval - Classify a string of text\n\
   \t-top_n:\n\
   \t\tNumber of predicted languages to output\n\
   \t-input;-i:\n\
   \t\tString to be classified if eval mode is used\n\
   \t\tMake sure your whole string is in quotes!!\n\n"

let rec play_game () =
  printf "Game line\n";
  let input =
    Out_channel.(flush stdout);
    In_channel.(input_line_exn stdin)
  in
  if String.( = ) input "" then play_game ()
  else (
    print_endline "";
    exit 1)

let evaluate input_text () =
  let classified = input_text |> Models.classify |> List.hd_exn in
  let language = Tuple2.get1 classified in
  let likelihood = Tuple2.get2 classified *. 100. in
  printf
    "You input:\n\
     %s\n\n\
     This is written in %s.\n\
     We say this with %.2f%% likelihood.\n\n\
     Thanks for using langid! :)%!" input_text language likelihood;
  print_endline "";
  Out_channel.(flush stdout)

let main () =
  let argc, args = CLI.init () in
  if argc = 1 then (
    printf "%s" help_print;
    exit 1);
  let mode = CLI.get_string_def [ "-mode" ] args "eval" in
  let input_text =
    match mode with
    | "eval" -> CLI.get_string_def [ "-input"; "-i" ] args ""
    | _ -> ""
  in
  let n = CLI.get_int_def [ "-top_n" ] args 1 in
  let help = CLI.get_set_bool [ "-h"; "-help" ] args in
  CLI.finalize ();
  match help with
  | true ->
      printf "%s" help_print;
      exit 1
  | false -> (
      match mode with
      | "game" -> play_game ()
      | "eval" -> evaluate input_text ()
      | _ ->
          printf "Bad mode parameter given:\n\t%s" mode;
          exit 1)

let () = main ()