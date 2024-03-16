open Ast

(** Type for evaluation errors. *)
exception EvalError of string

(** Evaluates the program argument. *)
val eval : stack -> command -> stack