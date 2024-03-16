%{
%}

%token <int> INT 
%token <string> IDENTIFIER
%token ASSN
%token SKIP
%token SEMICOLON
%token IF 
%token THEN 
%token ELSE 
%token WHILE
%token DO
%token TRUE
%token FALSE
%token PLUS 
%token LESS
%token STAR
%token EOF

%start <Ast.com> program 

%%

program:
    c=com EOF { c }

com:
    | SKIP { Ast.Skip }
    | id=IDENTIFIER ASSN a=aexp { Ast.Assn (id, a) }
    | c1=com SEMICOLON c2=com { Ast.Seq (c1, c2) }
    | IF b=bexp THEN c1=com ELSE c2=com { Ast.If (b, c1, c2) }
    | WHILE b=bexp DO c=com { Ast.While (b, c) }

aexp:
    | id=IDENTIFIER { Ast.Var (id) }
    | n=INT { Ast.Int (n) }
    | a1=aexp PLUS a2=aexp { Ast.Add (a1, a2) }
    | a1=aexp STAR a2=aexp { Ast.Mul (a1, a2) }

bexp:
    | TRUE { Ast.True }
    | FALSE { Ast.False }
    | a1=aexp LESS a2=aexp { Ast.Less (a1, a2) }