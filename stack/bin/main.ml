open Lexing
open Stack
open Eval
open Ast

(** Global stack. *)
let glbl_stack : stack ref = ref []

(** Print an error message and exit with code 1. *)
let err_exit (msg : string) =
  print_endline msg;
  exit 1

(** Return AST from source. *)
let parse (source : string) : command = 
  let lexbuf = from_string source in 
  Parser.program Lexer.token lexbuf

(** Execute code passed as a string argument. *)
let run_source (source : string) : unit = 
  let ast = parse source in 
  glbl_stack := eval !glbl_stack ast;
  print_stack !glbl_stack 

(** Return a files contents. *)
let get_file_contents (file_name : string) : string =
  let get_stream file_name = 
    try open_in file_name 
    with Sys_error _ -> err_exit @@ file_name ^ ": No such file or directory."
  in 
    try 
      let stream = get_stream file_name in
      let len = in_channel_length stream in
      let source = really_input_string stream len in
      close_in stream;
      source
    with End_of_file -> err_exit "The file you have passed seems to be inappropriate." 

(** Executes the code in the given file argument. *)
let run_file (file_name : string) : unit =
  run_source @@ get_file_contents file_name

(** Enter the read-eval-print loop. *)
let rec repl () : unit = 
  print_string "> ";
  let line = String.trim @@ read_line () in 
  match line with
  | "quit" | "exit" -> exit 0
  | _ -> begin 
      try run_source line
      with 
        | Parser.Error -> print_endline "Unknown or incomplete command: double check input command."
        | Lexer.LexerError msg | EvalError msg -> print_endline msg
    end;
    repl ()

(** Runs REPL or executes a file source depending on args to the executable. *)
let dispatch = function 
  | [] -> repl () 
  | [file] -> run_file file
  | _ -> print_endline "Usage: stack [file]"

(* Program entry point *)
let _ =
  let args =  List.tl @@ Array.to_list Sys.argv in 
  dispatch args