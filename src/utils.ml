open Core

(*TODO: Not needed, delete*)
let read_file_input (file_path: string): string list =
  let file = In_channel.create file_path in
  let strings = In_channel.input_lines file in
  In_channel.close file;
  strings

(*Load json string to a map, then converts to*)
let load_json_string (str: string): Yojson.Basic.t =
  let json2 = Yojson.Basic.from_file str in
  json2