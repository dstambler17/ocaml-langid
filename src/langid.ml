[@@@ocaml.warning "-33"]
[@@@ocaml.warning "-32"]
[@@@ocaml.warning "-26"]
[@@@ocaml.warning "-27"]

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

let game_prompt =
  "\n\
   Welcome to LangID! Can you beat me? I'll give you some text and some \
   language choices. \n\
  \  You'll get a point when you get it right, and a bonus if you get it right \
   and I don't. \n\
  \  Enter the number associated with the language you're guessing, or enter \
   STOP to end the game. Let's play!\n\n"

let bad_input_string =
  "You gave me bad input! You don't play by the rules, you're done!"

let num_choices = 4

(*
   Do most error handling for parsing of command line args with missing input
*)
let get_arg_safe get_type arg_names default args =
  let arg_raw =
    try Some (get_type arg_names args default)
    with CLI.No_param_for_option _ -> None
  in
  match arg_raw with Some m -> m | None -> default

let rec game_loop (user_score : int) (model_score : int) () =
  let sample = G.pick_targets (M.classes () |> List.unzip |> Tuple2.get1) in
  let sentence = Tuple2.get1 sample in
  let gt = Tuple2.get2 sample in
  let choices =
    G.game_choices gt (M.classes () |> List.unzip |> Tuple2.get1) num_choices
  in
  let model_correct =
    sentence |> M.classify |> List.hd_exn |> Tuple2.get1
    |> Fn.flip G.check_model_response choices
  in
  printf "Sentence:\n%s\nChoices (enter number):\n%s\n\n>> %!" sentence
    (G.user_option_string choices);
  let user_input =
    let raw_input =
      Out_channel.(flush stdout);
      In_channel.(input_line_exn stdin)
    in
    G.handle_user_errors raw_input
  in
  match user_input with
  | 0 ->
      printf "%s" (G.winner_string user_score model_score);
      Out_channel.(flush stdout);
      print_endline "";
      exit 1
  | -1 ->
      printf "%s" bad_input_string;
      print_endline "";
      exit 1
  | _ ->
      let user_correct = G.check_player_response (user_input - 1) choices in
      let user_points, model_points =
        G.evaluate_example user_correct model_correct
      in
      printf "%s\n" (G.event_string user_correct model_correct gt);
      Out_channel.(flush stdout);
      game_loop (user_score + user_points) (model_score + model_points) ()

let init_game () = game_loop 0 0 ()

let evaluate input_text () =
  let classified = input_text |> Models.classify |> List.hd_exn in
  let language = Tuple2.get1 classified in
  let likelihood = Tuple2.get2 classified *. 100. in
  printf
    "You input:\n\
     %s\n\n\
     This is written in %s.\n\
     We say this with %.2f%% likelihood.\n\n\
     Thanks for using langid! :)" input_text language likelihood;
  Out_channel.(flush stdout)

let main () =
  let argc, args = CLI.init () in
  if argc = 1 then (
    printf "%s" help_print;
    exit 1);
  let mode = get_arg_safe CLI.get_string_def [ "-mode" ] "eval" args in
  let input_text = get_arg_safe CLI.get_string_def [ "-input"; "-i" ] "" args in
  let fname = get_arg_safe CLI.get_string_def [ "-filename"; "-f" ] "" args in
  let n = get_arg_safe CLI.get_int_def [ "-top_n" ] 1 args in
  let help = CLI.get_set_bool [ "-h"; "-help" ] args in
  CLI.finalize ();
  match help with
  | true ->
      printf "%s" help_print;
      exit 1
  | false -> (
      match mode with
      | "game" ->
          Out_channel.(flush stdout);
          printf "%s" game_prompt;
          init_game ()
      | "eval" -> evaluate input_text ()
      | _ ->
          printf "Bad mode parameter given:\n\t%s" mode;
          exit 1)

let () = main ()