{
exception LexerError of string

let raise_error (lexbuf : Lexing.lexbuf) = 
  let pos = lexbuf.lex_curr_p in
  let msg = Printf.sprintf "Lexing error at line %d, character %d" pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1) in
  raise (LexerError msg)
}

let whitespace = [' ' '\t' '\r']
let newline = '\n'
let integer = '-'? ['0'-'9']+

rule token = parse
    | whitespace+ { token lexbuf }
    | newline { Lexing.new_line lexbuf; token lexbuf }
    | integer { Parser.INT (int_of_string (Lexing.lexeme lexbuf)) }
    | '#'    { skip_comment lexbuf }
    | "push" { Parser.PUSH }
    | "pop"  { Parser.POP}
    | "add"  { Parser.ADD }
    | "mul"  { Parser.MUL }
    | "dup"  { Parser.DUP }
    | "swap" { Parser.SWAP }
    | "skip" { Parser.SKIP }
    | "whilene" { Parser.WHILENE } 
    | '{' { Parser.LBRACE }
    | '}' { Parser.RBRACE } 
    | ';' { Parser.SEMICOLON }
    | eof { Parser.EOF }
    | _ { raise_error lexbuf }

and skip_comment = parse 
    | newline { Lexing.new_line lexbuf; token lexbuf }
    | eof { Parser.EOF }
    | _ { skip_comment lexbuf } 