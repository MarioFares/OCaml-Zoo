(** Type alias for iedentifiers. *)
type id = string

(** Type for arithmetic expressions. *)
type aexp = 
  | Var of id 
  | Int of int 
  | Add of aexp * aexp 
  | Mul of aexp * aexp 

(** Type for boolean expressions. *)
type bexp = 
  | True 
  | False 
  | Less of aexp * aexp 

(** Type for commands. *)
type com = 
  | Skip 
  | Assn of id * aexp 
  | Seq of com * com 
  | If of bexp * com * com
  | While of bexp * com 

