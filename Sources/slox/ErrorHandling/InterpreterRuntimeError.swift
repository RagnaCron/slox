//
//  RuntimeError.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

//import Foundation

class InterpreterRuntimeError: Error {
    let token: Token
    let message: String
    init(token: Token, message: String) {
        self.token = token
        self.message = message
    }
}
