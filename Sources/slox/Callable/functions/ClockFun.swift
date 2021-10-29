//
//  ClockFun.swift
//  
//
//  Created by RagnaCron on 29.10.21.
//

import Foundation

final class ClockFun: LoxCallable {
    public func arity() -> Int {
        return 0
    }
    
    public func call(_ callee: Interpreter, _ arguments: [Any?]) -> Any? {
        return Date().timeIntervalSince1970 * 1000
    }
    
    public var description: String {
        return "<Native clock function. Gets time interval since 1970 in milliseconds.>"
    }
}
