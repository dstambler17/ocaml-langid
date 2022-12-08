[@@@ocaml.warning "-33"]
[@@@ocaml.warning "-32"]
open Core

module M = Models
module G = Game


(* default values *)
let mode = ref ""
let top_n = ref 0
let usage = "usage: langid [-mode ['game' or 'eval']] [-top_n int (default = 1)]"

(* from http://rosettacode.org/wiki/Command-line_arguments#OCaml *)
let speclist = [
    ("-mode", Arg.String (fun s -> mode := s), ": option to play the game or evaluate text");
    ("-top_n", Arg.Int    (fun n -> top_n := n), ": number of language options in output");
  ]

(* let parseinput userinp =
  (* Read the arguments *)
  Printf.printf "String:%s\n" (Array.get userinp 2);
  Arg.parse_argv ?current:(Some (ref 0)) userinp
    speclist
    (fun x -> raise (Arg.Bad ("Bad argument : " ^ x)))
    usage;
  Printf.printf "Set stuff to:   %d '%s'\n%!"  !top_n !mode 
  Main functionality here *)

let _ =
  Printf.printf "We're workin' on it! :)"
