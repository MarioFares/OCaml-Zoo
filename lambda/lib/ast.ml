type id = string

type exp = 
  | Var of id
  | Abs of id * exp 
  | App of exp * exp

let rec string_of_exp = function 
  | Var v -> v 
  | Abs (v, e) -> "\\" ^ v ^ "." ^ string_of_exp e 
  | App (e1, e2) -> string_of_exp e1 ^ " " ^ string_of_exp e2