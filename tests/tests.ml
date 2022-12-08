[@@@ocaml.warning "-33"]

open Core
open OUnit2
module G = Game
module M = Models

let ex_langs = ["en";"es";"fr";"da"]
let ex_choices = [("en", true); ("zh", false); ("da", false)]
let ex_model_out1 = "en"
let ex_model_out2 = "da"
let ex_samples = [("hello", "en")]

let test_pick_targets _ = 
  assert_equal ("hello", "en") @@ G.pick_targets ex_samples

let test_game_choices _ = 
  assert_equal [("da", false);("en", true);("es", false);("fr", false)] @@ List.sort (G.game_choices "en" ex_langs 4) ~compare:(fun (x1, _) (x2, _) -> String.compare x1 x2)

let test_evaluate_example _ = 
  assert_equal 0.5 @@ G.evaluate_example true true;
  assert_equal 2. @@ G.evaluate_example false true;
  assert_equal 1. @@ G.evaluate_example true false;
  assert_equal 0. @@ G.evaluate_example false false

let test_player_response _ = 
  assert_equal true @@ G.check_player_response 0 ex_choices;
  assert_equal false @@ G.check_player_response 1 ex_choices

let test_model_response _ = 
  assert_equal true @@ G.check_model_response ex_model_out1 ex_choices;
  assert_equal false @@ G.check_model_response ex_model_out2 ex_choices

let test_evaluate_winner _ = 
  assert_equal "Ha-Ha, I win! AI will rule the world!" @@ G.winner_string 0 1;
  assert_equal "Great game, that was a hard-fought tie. Maybe we should play again to settle the score..." @@ G.winner_string 1 1;
  assert_equal "You beat me 2-1! Are you sure you're not a computer? Good game." @@ G.winner_string 2 1

let game_tests = "Game" >: test_list [
  "Test Evaluate Example" >:: test_evaluate_example;
  "Test Player Response" >:: test_player_response;
  "Test Model Response" >:: test_model_response;
  "Test Evaluate Winner" >:: test_evaluate_winner;
  "Test Pick Targets" >:: test_pick_targets;
  "Test Game Choices" >:: test_game_choices
  ]

let model_tests = "Model" >: test_list [
  (* Add tests here *)
  ]

let series = "Assignment2 Tests" >::: [
    game_tests;
    model_tests;
  ]

let () = 
  run_test_tt_main series
