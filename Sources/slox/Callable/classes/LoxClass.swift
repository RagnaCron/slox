//
//  LoxClass.swift
//  
//
//  Created by RagnaCron on 31.10.21.
//

final class LoxClass: LoxCallable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func arity() -> Int {
        return 0
    }
    
    func call(_ callee: Interpreter, _ arguments: [Any?]) -> Any? {
        let instance = LoxInstance(klass: self)
        return instance
    }
    
    var description: String {
        return name
    }
}
