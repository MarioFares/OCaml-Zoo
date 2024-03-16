open Ast

(** Type for evaluation errors. *)
exception EvalError of string

(** Return the top two elements of the stack. *)
let top_two (stack : stack) : int * int =
  try (List.hd stack, List.hd @@ List.tl stack)
  with Failure _ -> raise @@ EvalError "An operation/check that requires at least 2 elements in the stack was attemped unsuccessfully."

(** Applies arithmetic on top two elements, pops them, pushes the result. *)
let arith (f : int -> int -> int) (stack : stack) : stack = 
  let (n1, n2) = top_two stack in 
  let res = f n1 n2 in 
  res :: (List.tl @@ List.tl stack) 

(** Swaps the top of the stack with the ith element. *)
let swap (stack : stack) (i : int) : stack = 
  match stack with  
  | [] -> raise @@ EvalError "Swap called in an empty list."
  | hd :: tl when i = 0 -> hd :: tl 
  | hd :: _ ->  
    let rec aux acc count = function
      | [] -> raise @@ EvalError "Swap index out of bounds."
      | x :: xs when count = i -> x :: List.tl (List.rev_append acc (hd :: xs))
      | x :: xs -> aux (x :: acc) (count + 1) xs
    in
      aux [] 0 stack

(** Evaluates the program argument. *)
let rec eval (stack : stack) : command -> stack = function 
  | Push n -> n :: stack 
  | Pop -> 
    begin  
      try List.tl stack 
      with Failure _ -> raise @@ EvalError "Attempted to pop an empty stack." 
    end
  | Add -> arith (+) stack 
  | Mul -> arith ( * ) stack 
  | Dup -> 
    begin 
      try List.hd stack :: stack
      with Failure _ -> raise @@ EvalError "Attempted to duplicate in an empty stack." 
    end
  | Skip -> stack 
  | Seq (c1, c2) -> eval (eval stack c1) c2
  | Whilene c -> 
      let (n1, n2) = top_two stack in 
      if n1 <> n2 then eval (eval stack c) (Whilene c) 
      else stack
  | Swap i -> swap stack i
