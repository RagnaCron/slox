//
//  LoxFunction.swift
//  
//
//  Created by Osiris on 29.10.21.
//

class LoxFunction: LoxCallable {
    private let declaration: FunctionStatement
    
    init(declaration: FunctionStatement) {
        self.declaration = declaration
    }
    
    func arity() -> Int {
        declaration.parameters.count
    }
    
    func call(_ interpreter: Interpreter, _ arguments: [Any?]) -> Any? {
        let env = Environment(interpreter.globals)
        var index = 0
        while index < declaration.parameters.count {
            env.define(name: declaration.parameters[index].lexeme, value: arguments[index])
            index = index + 1
        }
        interpreter.executeBlock(statements: declaration.body, env: env)
        return nil
    }
    
    var description: String {
        return "function \(declaration.name.lexeme)"
    }
    
    
}
