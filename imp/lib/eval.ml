open Ast 

(** Module for a map with keys of type String. *)
module IDMap = Map.Make(String)

(** Type of a map from strings to ints. *)
type state = int IDMap.t

(** Return empty map. *)
let empty = IDMap.empty

(** Evaluate arithmetic expressions to an integer. *)
let rec eval_aexp (state : state) : aexp -> int = function
  | Var id -> IDMap.find id state 
  | Int n -> n 
  | Add (aexp1, aexp2) -> (eval_aexp state aexp1) + (eval_aexp state aexp2)
  | Mul (aexp1, aexp2) -> (eval_aexp state aexp1) * (eval_aexp state aexp2)

(** Evaluate boolean expressions to a boolean. *)
let eval_bexp (state : state) : bexp -> bool = function
  | True -> true
  | False -> false
  | Less (aexp1, aexp2) -> (eval_aexp state aexp1) < (eval_aexp state aexp2)

(** Evaluate commands to a map. *)
let rec eval_com (state : state) : com -> state = function 
  | Skip -> state
  | Assn (id, aexp) -> IDMap.add id (eval_aexp state aexp) state
  | Seq (c1, c2) -> eval_com (eval_com state c1) c2
  | If (bexp, c1, c2) -> 
    let b = eval_bexp state bexp in
    if b then eval_com state c1 else eval_com state c2
  | While (bexp, c) ->
    let b = eval_bexp state bexp in 
    if b then eval_com (eval_com state c) (While (bexp, c)) 
    else state