//
//  Environment.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

final class Environment {
    private var enclosing: Environment?
    private var values = [String : Any?]()
    
    public init() {
        self.enclosing = nil
    }
    
    public init(_ env: Environment) {
        self.enclosing = env
    }
    
    public func define(name: String, value: Any?) {
        values.updateValue(value, forKey: name)
    }
    
    public func assign(name: Token, value: Any?) throws {
        if values.contains(where: { (key: String, _) in key == name.lexeme }) {
            values.updateValue(value, forKey: name.lexeme)
            return
        }
        if let env = enclosing {
            try env.assign(name: name, value: value)
            return
        }
        throw InterpreterRuntimeError(token: name, message: "Undefined variable '\(name.lexeme)'.")
    }
    
    public func assignAt(_ distance: Int, name: Token, value: Any?) {
        ancestor(distance: distance).values.updateValue(value, forKey: name.lexeme)
    }
    
    public func get(name: Token) throws -> Any? {
        if let value = values[name.lexeme] {
            return value
        }
        
        if let env = enclosing {
            return try env.get(name:name)
        }
        throw InterpreterRuntimeError(token: name, message: "Undefined variable '\(name.lexeme)'.")
    }
    
    public func getAt(_ distance: Int, name: String) throws -> Any? {
        return ancestor(distance:distance).values[name]!
    }
    
    private func ancestor(distance: Int) -> Environment {
        var env = self
        var index = 0
        while index < distance {
            if let e = env.enclosing {
                env = e
            }
            index = index + 1
        }
        return env
    }
}
