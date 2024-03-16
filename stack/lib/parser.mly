%{
%}

%token <int> INT 
%token PUSH
%token POP 
%token ADD
%token MUL 
%token DUP
%token SWAP 
%token SKIP 
%token WHILENE
%token SEMICOLON
%token LBRACE
%token RBRACE
%token EOF

%start program
%type <Ast.command> program 

%%

program:
    c=command EOF { c }

command:
    | PUSH n=INT  { Ast.Push n }
    | POP         { Ast.Pop }
    | ADD         { Ast.Add }
    | MUL         { Ast.Mul }
    | DUP         { Ast.Dup }
    | SWAP n=INT  { Ast.Swap n }
    | SKIP        { Ast.Skip }
    | WHILENE LBRACE c=command RBRACE { Ast.Whilene c }
    | c1=command SEMICOLON c2=command { Ast.Seq (c1, c2) }