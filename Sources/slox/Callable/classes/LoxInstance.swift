//
//  LoxInstance.swift
//  
//
//  Created by RagnaCron on 31.10.21.
//

final class LoxInstance: CustomStringConvertible {
    private let klass: LoxClass
    private var fields = [String: Any]()
    
    init(klass: LoxClass) {
        self.klass = klass
    }
    
    var description: String {
        return "\(klass.name) instance"
    }
    
    func get(name: Token) throws -> Any {
        if let field = fields[name.lexeme] {
            return field
        }
        throw InterpreterRuntimeError(token: name, message: "Undefined property '" + name.lexeme + "'.")
    }
    
    func set(name: Token, value: Any) {
        fields[name.lexeme] = value
    }
    
}
