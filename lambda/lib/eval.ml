open Ast 

(** Determines the evaluation strategy for lambda calculus. *)
type eval_strategy = 
  | Value 
  | Name 
  | Beta

(** Call by name evaluation: substitute the argument as is. *)
let rec eval_by_name : exp -> exp = function
  | Var _ -> failwith "Variable cannot be evaluated." 
  | Abs (id, body) -> Abs (id, body)
  | App (e1, e2) -> 
    match eval_by_name e1 with
    | Abs (id, body) -> subst id e2 body 
    | _ -> failwith "First expression in an application must be an abstraction."
    
(** Substitute target_var for repl_e in target_exp. *)
and subst (target_var : id) (repl_e : exp) (target_exp : exp) : exp = 
  match target_exp with 
  | Var x -> if x = target_var then repl_e else Var x
  | Abs (id, body) -> Abs (id, subst target_var repl_e body)
  | App (e1, e2) -> App (subst target_var repl_e e1 , subst target_var repl_e e2)

(** Call by value evaluation: argument cannot be an application. *)
let rec eval_by_value : exp -> exp = function 
  | Var _ -> failwith "Variable cannot be evaluated."
  | Abs (id, body) -> Abs (id, body)
  | App (e1, e2) -> 
    match eval_by_value e1 with
    | Abs (id, body) -> subst id (eval_by_value e2) body 
    | _ -> failwith "First expression in an application must be an abstraction." 

(** Full beta reduction: most permissive evaluation strategy. *)
let rec eval_by_beta : exp -> exp = function 
  | Var _ -> failwith "Var cannot be evaluated."
  | Abs (id, body) -> Abs (id, eval_by_beta body) 
  | App (e1, e2) -> 
    match eval_by_beta e1 with
    | Abs (id, body) -> subst id e2 body
    | _ -> failwith "First expression in an application must be an abstraction."

(** Return the appropriate evaluation function based on strategy. *)
let eval_function : eval_strategy -> (exp -> exp) = function 
  | Value -> eval_by_value 
  | Name -> eval_by_name 
  | Beta -> eval_by_beta