{
exception LexerError of string

let raise_error (lexbuf : Lexing.lexbuf) = 
  let pos = lexbuf.lex_curr_p in
  let msg = Printf.sprintf "Lexing error at line %d, character %d" pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1) in
  raise (LexerError msg)

let reserved_symbols = [ 
  ("while", Parser.WHILE);
  ("skip", Parser.SKIP);
  ("if", Parser.IF);
  ("then", Parser.THEN);      
  ("else", Parser.ELSE);
  ("true", Parser.TRUE);
  ("false", Parser.FALSE);
  ("do", Parser.DO);
  ("end", Parser.END);
  (":=", Parser.ASSN);
  (";", Parser.SEMICOLON);
  ("+", Parser.PLUS);
  ("*", Parser.STAR);
  ("<", Parser.LESS);
]

let (symbol_table : (string, Parser.token) Hashtbl.t) = Hashtbl.create 1024
  let _ =
    List.iter (fun (str,t) -> Hashtbl.add symbol_table str t) reserved_symbols

let create_token lexbuf =
  let str = Lexing.lexeme lexbuf in 
  try (Hashtbl.find symbol_table str) 
  with _ -> Parser.IDENTIFIER str

}

let whitespace = [' ' '\t' '\r']
let newline = '\n'
let digit = ['0'-'9']
let integer = '-'? digit+
let lowercase = ['a'-'z']
let uppercase = ['A'-'Z']
let character = lowercase | uppercase


rule token = parse
    | whitespace+ { token lexbuf }
    | newline { Lexing.new_line lexbuf; token lexbuf }
    | integer { Parser.INT (int_of_string (Lexing.lexeme lexbuf)) }
    | character (digit | character | '_')* { create_token lexbuf }
    | ":=" | ";" | "+" | "*" | "<" { create_token lexbuf }
    | eof { Parser.EOF }
    | _ { raise_error lexbuf }