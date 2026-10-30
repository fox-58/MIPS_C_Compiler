# Plan for Processing Characters

1. Pass the letter to the function
2. If it is a space, deal with that token

#include -> read next item -> do nothig
int -> read next item -> either a function or a variable.
a. if function: create label. and set the state of smth to say you are inside that function so its easier to keep track of returns?? / you will keep going through the funcrtion anyways. nvm c99 standards, keep track of if its returning or returning wrong type for some sort of error message 
b. if varable keep reading and either a) set a register aside for this variable or b) set a regiser to equal to it

*deal with strings later
**deal with libraries later
