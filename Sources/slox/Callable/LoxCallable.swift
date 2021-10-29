//
//  LoxCallable.swift
//  
//
//  Created by RagnaCron on 29.10.21.
//

protocol LoxCallable: CustomStringConvertible {
    func arity() -> Int
    func call(_ callee: Interpreter, _ arguments: [Any?]) -> Any
}
