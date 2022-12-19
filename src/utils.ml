open Core

(*
 Taken from the NGram Assignment of the JHU functional course
 Allows for us to pass in a random module to file
*)
module type Randomness = sig
  (*
    Given a maximum integer value, return a pseudorandom integer from 0 (inclusive) to this value (exclusive).
  *)
  val int : int -> int
end

(* Helper function for sampling from list Takes a list and a random and returns option *)
let list_sample_helper (items : 'a list) (module R : Randomness) : 'a option =
  let rand_idx = R.int (List.length items) in
  let sample_tup =
    items |> List.findi ~f:(fun x _ -> Int.compare x rand_idx = 0)
  in
  match sample_tup with None -> None | Some (_, elem) -> Some elem
