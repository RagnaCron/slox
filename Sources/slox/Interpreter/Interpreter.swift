//
//  Interpreter.swift
//  
//
//  Created by RagnaCron on 26.10.21.
//

//import Foundation

class Interpreter: ExprVisitor {
    typealias ExprVisitorReturn = Any?
    
    public func visitBinary(expr: BinaryExpression) -> ExprVisitorReturn {
        let left = evaluate(expr.left)
        let right = evaluate(expr.right)
        guard let left = left, let right = right else {
            return nil
        }
        switch (expr.operation.type) {
        case .GREATER:
            if let l = left as? Double, let r = right as? Double {
                return l > r
            }
        case .GREATER_EQUAL:
            if let l = left as? Double, let r = right as? Double {
                return l >= r
            }
        case .LESS:
            if let l = left as? Double, let r = right as? Double {
                return l < r
            }
        case .LESS_EQUAL:
            if let l = left as? Double, let r = right as? Double {
                return l <= r
            }
        case .BANG_EQUAL:
            return !isEqual(left, right)
        case .EQUAL_EQUAL:
            return isEqual(left, right)
        case .MINUS:
            if let l = left as? Double, let r = right as? Double {
                return l - r
            }
        case .SLASH:
            if let l = left as? Double, let r = right as? Double {
                return l / r
            }
        case .STAR:
            if let l = left as? Double, let r = right as? Double {
                return l * r
            }
        case .PLUS:
            if let l = left as? Double, let r = right as? Double {
                return l + r
            }
            if let l = left as? String, let r = right as? String {
                return l + r
            }
        default:
            return nil
        }
        // Unreachable.
        return nil
    }
    
    public func visitGrouping(expr: GroupingExpression) -> ExprVisitorReturn {
        return evaluate(expr.expression)
    }
    
    public func visitLiteral(expr: LiteralExpression) -> ExprVisitorReturn {
        guard let value = expr.value.conent else {
            return nil
        }
        return value
    }
    
    public func visitUnary(expr: UnaryExpression) -> ExprVisitorReturn {
        let right = evaluate(expr.right);

        switch (expr.operation.type) {
        case .BANG:
                return !isTruthy(right)
        case .MINUS:
            guard let right = right else {
                return nil
            }
            if let r = right as? Double {
                return -r
            }
        default:
            break
        }
        // Unreachable.
        return nil
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
    
    private func evaluate(_ expr: Expr) -> ExprVisitorReturn {
        return expr.accept(visitor: self)
    }
    
}
