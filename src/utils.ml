open Core
[@@@ocaml.warning "-32"]


(*TODO: Not needed, delete*)
let read_file_input (file_path: string): string list =
  let file = In_channel.create file_path in
  let strings = In_channel.input_lines file in
  In_channel.close file;
  strings

(*
  
 Taken from Assignment 4 of the JHU functional course
 Allows for us to pass in a random module to file
*)
module type Randomness = sig
  (*
    Given a maximum integer value, return a pseudorandom integer from 0 (inclusive) to this value (exclusive).
  *)
  val int : int -> int
end
