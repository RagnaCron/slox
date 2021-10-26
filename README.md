# slox

An interpreter for Lox written in Swift. Provided for with an MIT License.

Robert Nystroms website: https://craftinginterpreters.com

Robert Nystroms git 'Crafting Interpreters': https://github.com/munificent/craftinginterpreters

Robert Nystroms git: https://github.com/munificent/


## Changes to the original jlox implemetation from Robert Nystrom

TokenType Enums:
 - "this" -> "self"
 
 Token struct (in java as a class):
 - The var literal in java is an Object, in slox it is a Literal enum that can store a String in the STRING case or a Double in the NUMBER case,
 for this it uses the enum feature for associating a Value directly with a case (See Swift Documentation on this matter).
 - It implements the CustomStringConvertible Protocol, to give a nice text representation of it self.
