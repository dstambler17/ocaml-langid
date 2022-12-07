open Core
open OUnit2
module G = Game
module M = Models


let game_tests = "Part 1" >: test_list [
    (* Add tests here *)
  ]

let model_tests = "Part 2" >: test_list [
  (* Add tests here *)
  ]
  (* Add another suite for any of your part II functions needing testing as well.  Make sure to put those functions in simpledict.ml and headers in simpledict.mli as only libraries are unit tested; keywordcount.ml is an executable not a library. *)
let series = "Assignment2 Tests" >::: [
    game_tests;
    model_tests;
  ]

let () = 
  run_test_tt_main series
