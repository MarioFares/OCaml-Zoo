# Language Overview

Below is a brief overview of the "stack" language.
Note that the name is generic and is just a placeholder.
The language syntax and semantics were inspired by an exercise 
in one of the problem sets of Harvard's CS152 course.


## Commands

- `c1; c2`: sequence of commands, `c1` is executed followed by `c2`.
- `push n`: pushes `n` onto the stack.
- `pop`: pops the top of the stack.
- `add`: pops the 2 top elements and pushes their sum on the stack.
- `mul`: pops the 2 top elements and pushes their product on the stack.
- `dup`: pushes a duplicate of the top element onto the stack.
- `swap i`: swaps the top element of the stack with the ith element. Indexing is 0-based.
- `skip`: does nothing.
- `whilene {c}`: loops and executes c while the top two elements of the stack are not equal.


## Other Notes

While not included in the official 152 specification, I implemented
the ability to add comments in the code. 

I also did not use OCaml's built-in stack implementation specifically 
because of the `swap` command, which I implemented anyway because it is
defined per the 152 spec.