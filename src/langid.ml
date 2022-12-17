[@@@ocaml.warning "-33"]
[@@@ocaml.warning "-32"]
[@@@ocaml.warning "-26"]

open Core
module M = Models
module G = Game
module CLI = Minicli.CLI

let arguments_print = Printf.printf
"\nArguments:\n\
\t-mode:\n\
\t\tgame - play a langid guessing game against the model\n\
\t\teval - classify a string of text\n\
\t-top_n:\n\
\t\tnumber of predicted languages to output\n\
\t-input;-i:\n\
\t\tstring to be classified if eval mode is used\n\n%!"

let example_print = Printf.printf "\nExample usage:\n\t./langid.exe -mode <string> -top_n <int> -input <string> [-h;-help]\n\n%!"

let main () =
  let argc, args = CLI.init () in
  if argc = 1 then (
    example_print;
    arguments_print;
    exit 1);
  let mode = CLI.get_string_def [ "-mode" ] args "eval" in
  let input_text = match mode with
  | "eval" -> CLI.get_string_def ["-input";"-i"] args ""
  | _ -> "" in
  let n = CLI.get_int_def [ "-top_n" ] args 1 in
  let help = CLI.get_set_bool [ "-h" ] args in
  CLI.finalize ();
  match help with 
  | true -> (example_print; arguments_print)
  | false -> ()
let () = main ()
