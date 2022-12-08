[@@@ocaml.warning "-33"]
open Core

module M = Models
module G = Game


let usage_msg = "langid --mode ['game' or 'eval'] [--verbose]"
let verbose = ref false
let mode = ref ""
let output_file = ref ""
let top_n = ref 1

let speclist =
  [("-verbose", Arg.Set verbose, "Output debug information");
   ("-mode", Arg.Set_string mode, "Set name");
   ("-top_n", Arg.Set_int top_n, "Set number of ranked langs in output")  
  ]

let () =
  Arg.parse speclist usage_msg;
  Printf.printf mode
  (* Main functionality here *)