# Overview

This repository is a collection of programming languages
implemented in OCaml for the purpose of demonstrating various
interpreter techniques along with common OCaml paradigms.

Many of the languages implemented were directly inspired
by Harvard's programming languages course, CS152. My hope
is that, among other things, future students of the class
would have access to these implementations to test their
understanding of these languages. 

Besides being inspired by 152, this repository was inspired
by several "language zoos" on Github that are similar in spirit.
My personal objective with this project is not only to provide
something relevant to 152 students, but also to expand my 
OCaml and interpreter building skill-set. Programming language
design and implementation is a very rich and rewarding 
area of study, and this repository is how I intend to delve 
further into it.

I did not name this a "programming language zoo" since I did
not want to limit myself to just programming languages. OCaml
is a very powerful language that has some excellent tooling
for lexing and parsing, two things that are used in areas
beyond just interpreter implementation. My hope with this project
is to implement things like code formatters, configuration DSLs,
etc.

Another thing that I set out to do in this project is to provide
VSCode extensions for each language, to cover things that are
very basic like syntax highlighting and auto-closing pairs.

A final important note: the reader might notice there is 
some repeated code in each language, especially for reading
and executing files. This is intentional, since I want to make
it as easy as possible for someone interested in a particular
language to simply copy that folder without having to pull
other dependencies from the repository. Therefore, each sub-folder
is self-contained. If you want to modify the language and tweak
it, you can simply copy the relevant folder.

# Requirements 

This repository uses 

- OCaml Compiler, version 4.14.1
- ocamllex 
- menhir, version 2.1
