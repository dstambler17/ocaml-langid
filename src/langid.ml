open Core
open Printf
open Stdio
module M = Models
module G = Game

let usage_msg =
  "Example usage:\n\
   \t./langid.exe -mode <string> -top_n <int> -input <string> [-help]\n"

let game_prompt () =
  "\n\
   Welcome to LangID! Can you beat me? I'll give you some text and some \
   language choices. \n\
  \  You'll get a point when you get it right, and a bonus if you get it right \
   and I don't. \n\
  \  Enter the number associated with the language you're guessing, or enter \
   STOP to end the game. Let's play!\n\n"

let bad_input_string () =
  "You gave me bad input! You don't play by the rules, you're done!"

let mode = ref "eval"
let input_text = ref ""
let n = ref 3

let speclist =
  [
    ( "-mode",
      Arg.Set_string mode,
      "Usage mode:\n\
       \tgame - Play a langid guessing game against the model\n\
       \teval - Classify a string of text" );
    ( "-top_n",
      Arg.Set_int n,
      "Number of most-probable languages to output. Default = 3." );
    ( "-input",
      Arg.Set_string input_text,
      "String to be classified if eval mode is used. Make sure your string is surrounded by quotes! Default = \"\"" );
  ]

let num_choices () = 4

let top_choices_string preds () =
  preds
  |> List.map ~f:(fun (lang, prob) ->
         (List.Assoc.find_exn (M.classes ()) ~equal:String.( = ) lang, prob))
  |> List.fold
       ~f:(fun str cur ->
         str ^ sprintf "%s: %.2f\n" (Tuple2.get1 cur) (Tuple2.get2 cur *. 100.))
       ~init:""

let rec game_loop (user_score : int) (model_score : int) () =
  let sample = G.pick_targets (M.classes () |> List.unzip |> Tuple2.get1) in
  let sentence = Tuple2.get1 sample in
  let gt = Tuple2.get2 sample in
  let choices =
    G.game_choices gt
      (M.classes () |> List.unzip |> Tuple2.get1)
      (num_choices ())
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
      printf "%s" (bad_input_string ());
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

let evaluate input_text top_k () =
  let classified = input_text |> Models.classify |> List.hd_exn in
  let language =
    List.Assoc.find_exn (M.classes ()) ~equal:String.( = )
      (Tuple2.get1 classified)
  in
  let likelihood = Tuple2.get2 classified *. 100. in
  let k_preds = M.top_choices input_text top_k in
  printf
    "You input:\n\
     %s\n\n\
     This is written in %s, with %.2f%% likelihood.\n\n\
     The full read-out of the top %d languages we predict is:\n\
     %s\n\n\
     Thanks for using langid! :)" input_text language likelihood top_k
    (top_choices_string k_preds ());
  Out_channel.(flush stdout)

let main mode () =
  match !mode with
  | "game" ->
      Out_channel.(flush stdout);
      printf "%s" (game_prompt ());
      init_game ()
  | "eval" -> evaluate !input_text !n ()
  | _ ->
      printf "Bad mode parameter given:\n\t%s" !mode;
      exit 1

let () =
  Arg.parse speclist
    (fun anon -> print_endline ("Anonymous argument: " ^ anon))
    usage_msg;
  main mode ()
