%{
%}

%token<Ast.id> VAR

%token EOF
%token SLASH
%token DOT 
%token LPAREN
%token RPAREN 

%start <Ast.exp> program

%%
program:
    e=exp EOF { e }

exp:
    | LPAREN e=exp RPAREN { e }
    | v=VAR { Ast.Var v }
    | SLASH v=VAR DOT e=exp { Ast.Abs (v, e) }
    | e1=exp e2=exp { Ast.App (e1, e2) }