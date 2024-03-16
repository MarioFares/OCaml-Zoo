{
open Parser
}

let whitespace = [' ' '\t' '\r']

rule token = parse
    | whitespace+ { token lexbuf }
    |  '\\' { SLASH }
    | '.'   { DOT }
    | '('   { LPAREN }
    | ')'   { RPAREN }
    | ['a'-'z' 'A'-'Z']+ as var { VAR var }
    | eof { EOF }
    | _ { failwith ("Unexpected character: " ^ Lexing.lexeme lexbuf)}