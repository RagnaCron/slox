//
//  LoxCallable.swift
//  
//
//  Created by RagnaCron on 29.10.21.
//

protocol LoxCallable {
    func arity() -> Int
    func call(_ callee: Interpreter, _ arguments: [Any?])
}
