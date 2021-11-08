//
//  LoxFunction.swift
//  
//
//  Created by Osiris on 29.10.21.
//

class LoxFunction: LoxCallable {
    private let declaration: FunctionStatement
    private let closure: Environment
    
    init(declaration: FunctionStatement, closure: Environment) {
        self.declaration = declaration
        self.closure = closure
    }
    
    func arity() -> Int {
        declaration.parameters.count
    }
    
    func call(_ interpreter: Interpreter, _ arguments: [Any?]) -> Any? {
        let env = Environment(closure)
        var index = 0
        while index < declaration.parameters.count {
            env.define(name: declaration.parameters[index].lexeme, value: arguments[index])
            index = index + 1
        }
        do {
            try interpreter.executeBlock(statements: declaration.body, env: env)
        } catch {
            if let returnExeption = error as? ReturnError {
                return returnExeption.value
            }
        }
        return nil
    }
    
    var description: String {
        return "function \(declaration.name.lexeme)"
    }
    
    func bind(_ instance: LoxInstance) -> LoxFunction {
        let env = Environment(closure)
        env.define(name: "self", value: instance)
        return LoxFunction(declaration: declaration, closure: env)
    }
}
