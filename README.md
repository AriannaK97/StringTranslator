# JavaTranslator_mini

This is a part of a Compiler's class Homework (Spring 2020).

## Tools used
 * JFlex
 * JavaCUP

## Comments:
I have used the ”){” terminals as one terminal named CR (conflict resolver),
in order to solve the shift/reduce conflict between the non-terminals call args
and decl args.
The parser worked for all the examples given. In order to compile and run
the program do the following (where input.txt contains the parser’s input):
$make
$make execute < input.txt
