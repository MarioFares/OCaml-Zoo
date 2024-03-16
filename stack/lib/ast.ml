(** The type for the global program stack. *)
type stack = int list

(** Prints the stack. *)
let print_stack (stack : stack) : unit = 
  print_string "[ ";
  List.iter (fun x -> print_string @@ string_of_int x; print_string " ") stack;
  print_endline "]"

(** The type for commands. *)
type command = 
  | Push of int 
  | Pop 
  | Add 
  | Mul 
  | Dup 
  | Swap of int 
  | Whilene of command 
  | Skip 
  | Seq of command * command

(** Returns a command as a string, also doubles as a formatter. *)
let string_of_command (c : command) : string = 
  let rec format_helper (c : command) (indent : bool) : string =
    let base =
      match c with
      | Push i -> "push " ^ string_of_int i 
      | Pop -> "pop" 
      | Add -> "add" 
      | Mul -> "mul" 
      | Dup -> "dup" 
      | Swap i -> "swap " ^ string_of_int i 
      | Whilene c -> "whilene {\n" ^ format_helper c true ^ "\n}";
      | Skip -> "skip" 
      | Seq (c1, c2) -> format_helper c1 indent ^ ";\n" ^ format_helper c2 indent
    in 
      if indent then "    " ^ base else base
  in 
    format_helper c false 

