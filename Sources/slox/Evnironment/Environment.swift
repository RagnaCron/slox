//
//  Environment.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

final class Environment {
    private var values = [String : Any?]()
    
    public func define(name: String, value: Any?) {
        values.updateValue(value, forKey: name)
    }
    
    public func get(name: Token) throws -> Any? {
        if let value = values[name.lexeme] {
            return value
        }
        throw InterpreterRuntimeError(token: name, message: "Undefined variable '\(name.lexeme)'.")
    }
}
