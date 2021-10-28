//
//  Environment.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

final class Environment {
    private var environment: Environment?
    private var values = [String : Any?]()
    
    public init() {
        self.environment = nil
    }
    
    public init(_ env: Environment) {
        self.environment = env
    }
    
    public func define(name: String, value: Any?) {
        values.updateValue(value, forKey: name)
    }
    
    public func assign(name: Token, value: Any?) throws {
        if values.contains(where: { (key: String, _) in key == name.lexeme }) {
            values.updateValue(value, forKey: name.lexeme)
            return
        }
        if let env = environment {
            try env.assign(name: name, value: value)
            return
        }
        throw InterpreterRuntimeError(token: name, message: "Undefined variable '\(name.lexeme)'.")
    }
    
    public func get(name: Token) throws -> Any? {
        if let value = values[name.lexeme] {
            return value
        }
        
        if let env = environment {
            return try env.get(name:name)
        }
        throw InterpreterRuntimeError(token: name, message: "Undefined variable '\(name.lexeme)'.")
    }
}