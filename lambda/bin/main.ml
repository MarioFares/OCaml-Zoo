open Lambda
open Ast
open Lexer 
open Lexing
open Parser
open Eval

(** The evaluation strategy. *)
let eval_strategy : eval_strategy ref = ref Name

(** Print an error message and exit with code 1. *)
let err_exit msg =
  print_endline msg;
  exit 1

(** Execute code passed as a string argument. *)
let run_source source =
  let fn = eval_function !eval_strategy in
  print_endline @@ string_of_exp @@ fn @@ program token @@ from_string source

(** Executes the code in the given file argument. *)
let run_file file_name =
  let get_stream file_name =
    try open_in file_name
    with Sys_error _ -> err_exit @@ file_name ^ ": No such file or directory"
  in
  try
    let stream = get_stream file_name in
    let len = in_channel_length stream in
    let source = really_input_string stream len in
    close_in stream;
    run_source source
  with End_of_file ->
    err_exit "The file you have passed seems to be inappropriate"

(** Enter the read-eval-print loop. *)
let rec repl () =
  print_string "> ";
  let line = String.trim @@ read_line () in
  match line with
  | "quit" | "exit" -> exit 0
  | _ ->
      run_source line;
      repl ()

let parse_args () = 
  let usage_msg = "Usage: lambda [script] [-eval <strategy>]" in 
  let arg_spec = 
    [ "-eval", Arg.Symbol (["name"; "value"; "beta"],
      (fun s -> eval_strategy := match s with
        | "name" -> Name 
        | "value" -> Value 
        | "beta" -> Beta
        | _ -> err_exit "Invalid evaluation strategy.")
      ),
      "Set evaluation strategy."
    ]
  in Arg.parse arg_spec (fun _ -> ()) usage_msg

(** Runs REPL or executes a file source depending on args to the executable. *)
let dispatch = function
  | [] 
  | "-eval" :: _ -> repl () 
  | hd :: _ -> run_file hd

let _ =
  parse_args ();
  let args = Array.to_list Sys.argv in
  dispatch @@ List.tl args