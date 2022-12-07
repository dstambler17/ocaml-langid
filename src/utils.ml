open Core
[@@@ocaml.warning "-32"]


(*TODO: Not needed, delete*)
let read_file_input (file_path: string): string list =
  let file = In_channel.create file_path in
  let strings = In_channel.input_lines file in
  In_channel.close file;
  strings

