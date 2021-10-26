# slox

An interpreter for Lox written in Swift. Provided for with an MIT License.

Robert Nystroms website: https://craftinginterpreters.com
Robert Nystroms git: https://github.com/munificent/
Robert Nystroms git 'Crafting Interpreters': https://github.com/munificent/craftinginterpreters

## Changes to the original jlox implemetation by Robert Nystrom

TokenType Enums:
 - "this" -> "self"
 
 Token struct (in java as a class):
 - the var literal in java is an Object, in slox it is a Literal enum that can store a String or a Double.
 - it implements the CustomStringConvertible Protocol.
