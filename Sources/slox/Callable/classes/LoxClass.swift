//
//  LoxClass.swift
//  
//
//  Created by RagnaCron on 31.10.21.
//

final class LoxClass: LoxCallable {
    let name: String
    private let methods: [String: LoxFunction]
    
    init(name: String, methods: [String: LoxFunction]) {
        self.name = name
        self.methods = methods
    }
    
    func arity() -> Int {
        return 0
    }
    
    func call(_ callee: Interpreter, _ arguments: [Any?]) -> Any? {
        let instance = LoxInstance(klass: self)
        return instance
    }
    
    func find(method: String) -> LoxFunction? {
        if let fun = methods[method] {
            return fun
        }
        return nil
    }
    
    var description: String {
        return name
    }
}
