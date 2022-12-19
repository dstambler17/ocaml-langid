[@@@ocaml.warning "-33"]

open Core
open OUnit2
open Utils

module G = Game
module M = Models
module S = Sampler

(* Declare a seeded random module for ease of testing. Always returns last elem *)
module SeededRandom : Randomness = struct  
  let int (max_val: int): int = max_val - 1
end

(* Bad random used so that some functions can hit the None case *)
module BadRandom : Randomness = struct  
  let int (max_val: int): int = max_val + 10000
end

let ex_langs = ["en";"es";"fr";"da"]
let ex_choices = [("en", true); ("zh", false); ("da", false)]
let ex_model_out1 = "en"
let ex_model_out2 = "da"
let ex_samples = ["en"; "da"]

(*TODO: TO BE CERTAIN THIS WORKS, RUN THIS 50 times and ensure results are returned in each one as a test case *)
let test_pick_targets _ = 
  assert_equal ("hello", "en") @@ G.pick_targets ex_samples

let test_game_choices _ = 
  assert_equal [("da", false);("en", true);("es", false);("fr", false)] @@ List.sort (G.game_choices "en" ex_langs 4) ~compare:(fun (x1, _) (x2, _) -> String.compare x1 x2)

let test_user_option_string _ = 
  assert_equal "(1) en (2) zh (3) da " @@ G.user_option_string ex_choices

let test_evaluate_example _ = 
  assert_equal (1, 1) @@ G.evaluate_example true true;
  assert_equal (1, 0) @@ G.evaluate_example false true;
  assert_equal (0, 1) @@ G.evaluate_example true false;
  assert_equal (0, 0) @@ G.evaluate_example false false

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

let test_event_string _ = 
  assert_equal "You were correct, as was I! It was indeed en\n" @@ G.event_string true true ex_model_out1;
  assert_equal "Ah! You got me on this one. I'll get you next time...\n" @@ G.event_string true false ex_model_out1;
  assert_equal "Ha! One for me, none for you! The actual answer was en\n" @@ G.event_string false true ex_model_out1;
  assert_equal "Seems we're both bad at this - no points for either of us. The actual answer was en\n" @@ G.event_string false false ex_model_out1

let game_tests = "Game" >: test_list [
  "Test Evaluate Example" >:: test_evaluate_example;
  "Test Player Response" >:: test_player_response;
  "Test Model Response" >:: test_model_response;
  "Test Evaluate Winner" >:: test_evaluate_winner;
  "Test Pick Targets" >:: test_pick_targets;
  "Test Game Choices" >:: test_game_choices;
  "Test Game Option String" >:: test_user_option_string;
  "Test Event String" >:: test_event_string
  ]

(*** MODEL TESTS ***)
let test_get_state_count_map _ =
  assert_equal true @@ G.check_player_response 0 ex_choices

let test_get_index_count_list _ =
  assert_equal true @@ G.check_player_response 0 ex_choices

let test_instance2fv _ = 
  assert_equal true @@ G.check_player_response 0 ex_choices

let test_nb_classprobs _ =
  assert_equal true @@ G.check_player_response 0 ex_choices

let test_norm_probs _ =
  assert_equal true @@ G.check_player_response 0 ex_choices

let test_top_choices _ =
  assert_equal true @@ G.check_player_response 0 ex_choices

let test_rank _ =
  assert_equal true @@ G.check_player_response 0 ex_choices

let test_classify _ =
  assert_equal true @@ G.check_player_response 0 ex_choices

let model_tests = "Model" >: test_list [
  (* Add tests here *)
  "Test Get State Count Map" >:: test_get_state_count_map;
  "Test Get Index Count List" >:: test_get_index_count_list;
  "Test Instance To Feature Vector" >:: test_instance2fv;
  "Test Model Inference" >:: test_nb_classprobs;
  "Test Norm Probs" >:: test_norm_probs;
  "Test Top Choices" >:: test_top_choices;
  "Test Rank" >:: test_rank;
  "Test Classify" >:: test_classify
  ]

(*** SAMPLER TESTS ***)

(* Declare Some consts for testing html cleaning*)
let ex_html_input = 
  "<html>
   <head>
     <title>Example Page</title>
   </head>
   <body>
      <script>
      var x = 50 + 75 ; I think this is JS syntax, haha
      </script>
      <style>
      {
        h1: {
          font-size: 5 em;
          color: blue;
        }
      }
      </style>
     <h1>Welcome to my page-->!</h1>
     <p>This is &#97;some text with a <a href='http://www.example.com'>link</a> in it.</p>
     <p>This is some\n more text with\t a <strong>bold</strong> word in it.</p>
     <p>This is a paragraph with a <time datetime='2022-12-19T18:30'>time</time> in it.</p>
    <nav>This should also be cleaned</nav>
    <table>Table stuff goes here</table>
     </body>
   <footer>
   This is my footer
   </footer>
  </html>"

let clean_html_output = 
  "Welcome to my page ! This is some text with a link in it. This is a paragraph with a time in it."

let test_get_html_body _ =
  (*Tests that <body> is in the response item. Yes, example.com is apperently a real website *)
  let resp_list = String.split ~on:'\n' (S.get_html_body "http://example.com/") in
  let opt_res = resp_list |> List.find ~f:(fun elem -> String.(=) "<body>" (String.strip elem)) in
  assert_equal (Some "<body>") @@ opt_res

let test_strip_html _ =
  assert_equal clean_html_output @@ S.strip_html ex_html_input

let test_build_url _ =
  assert_equal None @@ @@ build_url "en" (module BadRandom); 
  assert_equal (Some "https://en.wikipedia.org/wiki/OpenAI") @@ build_url "en" (module SeededRandom) 

let test_sample_text _ =
  let sampled_res_opt =  sample_text "en" 10 (module BadRandom) in
  assert_equal None @@ @@ sample_text "en" 10 (module BadRandom); 

  
let sampler_tests = "Sampler" >: test_list [
  "Test Request URL" >:: test_get_html_body;
  "Test Strip HTML" >::  test_strip_html;
  "Test Build URL" >:: test_build_url;
  "Test Sample Text" >:: test_sample_text
  ]

let test_list_sample_helper _ =
  let test_list = [1; 2; 3; 4; 5] in
  assert_equal None @@ list_sample_helper test_list (module BadRandom);
  assert_equal (Some 5) @@ list_sample_helper test_list (module SeededRandom) 

let utils_tests = "Utils" >: test_list [
  "Test List Sample Helper" >:: test_list_sample_helper
]

let series = "Ocaml LangID Project Tests" >::: [
    game_tests;
    model_tests;
    sampler_tests;
    utils_tests; 
  ]

let () = 
  run_test_tt_main series
