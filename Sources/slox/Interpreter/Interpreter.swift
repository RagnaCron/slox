//
//  Interpreter.swift
//  
//
//  Created by RagnaCron on 26.10.21.
//

import Foundation

class Interpreter: ExprVisitor {
    typealias ExprVisitorReturn = Any?
    
    public func interpret(expression: Expr) {
        do {
            let value = try evaluate(expression)
            print(strinify(value))
        } catch {
            Lox.runtimeError(error as! InterpreterRuntimeError)
        }
    }
    
    public func visitBinary(expr: BinaryExpression) throws -> ExprVisitorReturn {
        let left = try evaluate(expr.left)
        let right = try evaluate(expr.right)
        guard let left = left, let right = right else {
            return nil
        }
        switch (expr.operation.type) {
        case .GREATER:
            let (le,ri) = try checkNumber(expr.operation, left, right)
            return le > ri
        case .GREATER_EQUAL:
            let (le,ri) = try checkNumber(expr.operation, left, right)
            return le >= ri
        case .LESS:
            let (le,ri) = try checkNumber(expr.operation, left, right)
            return le < ri
        case .LESS_EQUAL:
            let (le,ri) = try checkNumber(expr.operation, left, right)
            return le <= ri
        case .BANG_EQUAL:
            return !isEqual(left, right)
        case .EQUAL_EQUAL:
            return isEqual(left, right)
        case .MINUS:
            let (le,ri) = try checkNumber(expr.operation, left, right)
            return le - ri
        case .SLASH:
            let (le,ri) = try checkNumber(expr.operation, left, right)
            return le / ri
        case .STAR:
            let (le,ri) = try checkNumber(expr.operation, left, right)
            return le * ri
        case .PLUS:
            if let l = left as? Double, let r = right as? Double {
                return l + r
            }
            if let l = left as? String, let r = right as? String {
                return l + r
            }
            throw InterpreterRuntimeError(token: expr.operation, message: "Operands must be two numbers or two strings.")
        default:
            return nil
        }
    }
    
    public func visitGrouping(expr: GroupingExpression) throws -> ExprVisitorReturn {
        return try evaluate(expr.expression)
    }
    
    public func visitLiteral(expr: LiteralExpression) throws -> ExprVisitorReturn {
        guard let value = expr.value.conent else {
            return nil
        }
        return value
    }
    
    public func visitUnary(expr: UnaryExpression) throws -> ExprVisitorReturn {
        let right = try evaluate(expr.right);

        switch (expr.operation.type) {
        case .BANG:
                return !isTruthy(right)
        case .MINUS:
            let r = try checkNumber(expr.operation, right)
            return -r
        default:
            break
        }
        // Unreachable.
        return nil
    }
    
    private func checkNumber(_ operation: Token, _ operand: ExprVisitorReturn) throws -> Double {
        guard let right = operand else {
            throw InterpreterRuntimeError(token: operation, message: "Operand must be a number.")
        }
        if let r = right as? Double {
            return r
        }
        throw InterpreterRuntimeError(token: operation, message: "Operand must be a number.")
    }
    
    private func checkNumber(_ operation: Token, _ left: ExprVisitorReturn, _ right: ExprVisitorReturn) throws -> (left: Double, right: Double) {
        guard let left = left, let right = right else {
            throw InterpreterRuntimeError(token: operation, message: "Operand must be a number.")
        }
        if let l = left as? Double, let r = right as? Double {
            return (left: l, right: r)
        }
        throw InterpreterRuntimeError(token: operation, message: "Operand must be a number.")
    }
    
    private func isTruthy(_ object: Any?) -> Bool {
        guard let object = object else {
            return false
        }
        if let b = object as? Bool {
            return b
        }
        return true
    }
    
    private func isEqual(_ left: Any?, _ right: Any?) -> Bool {
        if left == nil && right == nil {
            return true
        }
        if left == nil {
            return false
        }
        guard type(of: left!) == type(of: right!) else {
            return false
        }
        if let l = left as? String, let r = right as? String {
            return l == r
        }
        if let l = left as? Bool, let r = right as? Bool {
            return l == r
        }
        if let l = left as? Double, let r = right as? Double {
            return l == r
        }
//        if let l = left as? LoxFunction, let r = right as? LoxFunction {
//            return l == r
//        }
        return false
    }
    
    private func strinify(_ object: ExprVisitorReturn) -> String {
        guard let object = object else {
            return "nil"
        }
        if let o = object as? Double {
            var text = String(o)
            if text.hasSuffix(".0") {
                text.removeLast(2)
            }
            return String(text)
        }
        return "\(object)"
    }
    
    private func evaluate(_ expr: Expr) throws -> ExprVisitorReturn {
        return try expr.accept(visitor: self)
    }
    
}
