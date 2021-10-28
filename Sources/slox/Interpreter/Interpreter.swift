//
//  Interpreter.swift
//  
//
//  Created by RagnaCron on 26.10.21.
//

import Foundation

class Interpreter: ExpressionVisitor, StatementVisitor {
    typealias Statements = [Statement]
    typealias ExpressionVisitorReturnType = Any?
    
    private var environment = Environment()
    
    public func interpret(_ statements: Statements) {
        do {
            for statement in statements {
                try execute(statement)
            }
        } catch {
            Lox.runtimeError(error as! InterpreterRuntimeError)
        }
    }
    
    func visitAssign(expr: AssignExpression) throws -> ExpressionVisitorReturnType {
        let value = try evaluate(expr.value)
        try environment.assign(name: expr.name, value: value)
        return value
    }
    
    func visitBinary(expr: BinaryExpression) throws -> ExpressionVisitorReturnType {
        guard let left = try evaluate(expr.left), let right = try evaluate(expr.right) else {
            return nil
        }
        switch (expr.operation.type) {
        case .GREATER:
            let (le,ri) = try checkNumbers(expr.operation, left, right)
            return le > ri
        case .GREATER_EQUAL:
            let (le,ri) = try checkNumbers(expr.operation, left, right)
            return le >= ri
        case .LESS:
            let (le,ri) = try checkNumbers(expr.operation, left, right)
            return le < ri
        case .LESS_EQUAL:
            let (le,ri) = try checkNumbers(expr.operation, left, right)
            return le <= ri
        case .BANG_EQUAL:
            return !isEqual(left, right)
        case .EQUAL_EQUAL:
            return isEqual(left, right)
        case .MINUS:
            let (le,ri) = try checkNumbers(expr.operation, left, right)
            return le - ri
        case .SLASH:
            let (le,ri) = try checkNumbers(expr.operation, left, right)
            return le / ri
        case .STAR:
            let (le,ri) = try checkNumbers(expr.operation, left, right)
            return le * ri
        case .PLUS:
            if let l = left as? Double, let r = right as? Double {
                return l + r
            }
            if let l = left as? String, let r = right as? String {
                return l + r
            }
            if let l = left as? Double, let r = right as? String {
                return removeZeros(l) + r
            }
            if let l = left as? String, let r = right as? Double {
                return l + removeZeros(r)
            }
            throw InterpreterRuntimeError(token: expr.operation, message: "Operands must be two numbers or number + string.")
        default:
            return nil
        }
    }
    
    func visitGrouping(expr: GroupingExpression) throws -> ExpressionVisitorReturnType {
        return try evaluate(expr.expression)
    }
    
    func visitLiteral(expr: LiteralExpression) throws -> ExpressionVisitorReturnType {
        guard let value = expr.value.conent else {
            return nil
        }
        return value
    }
    
    func visitUnary(expr: UnaryExpression) throws -> ExpressionVisitorReturnType {
        let right = try evaluate(expr.right);
        switch (expr.operation.type) {
        case .BANG:
                return !isTruthy(right)
        case .MINUS:
            return -(try checkNumber(expr.operation, right))
        default:
            // unreachable
            return nil
        }
    }
    
    func visitVariable(expr: VariableExpression) throws -> ExpressionVisitorReturnType {
        return try environment.get(name:expr.name)
    }
    
    private func checkNumber(_ operation: Token, _ operand: ExpressionVisitorReturnType) throws -> Double {
        if let right = operand as? Double {
            return right
        }
        throw InterpreterRuntimeError(token: operation, message: "Operand must be a number.")
    }
    
    private func checkNumbers(_ operation: Token, _ left: ExpressionVisitorReturnType, _ right: ExpressionVisitorReturnType) throws -> (left: Double, right: Double) {
        if let left = left as? Double, let right = right as? Double {
            if right == 0  {
                throw InterpreterRuntimeError(token: operation, message: "Division by zero is not possible.")
            }
            return (left, right)
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
    
    private func stringify(_ object: ExpressionVisitorReturnType) -> String {
        guard let object = object else {
            return "nil"
        }
        if let number = object as? Double {
            return removeZeros(number)
        }
        return "\(object)"
    }
    
    private func removeZeros(_ number: Double) -> String {
        var text = String(number)
        if text.hasSuffix(".0") {
            text.removeLast(2)
        }
        return String(text)
    }
    
    private func evaluate(_ expr: Expression) throws -> ExpressionVisitorReturnType {
        return try expr.accept(visitor: self)
    }
    
    private func execute(_ statement: Statement) throws {
        try statement.accept(visitor: self)
    }
    
    private func executeBlock(statements: Statements, env: Environment) {
        let previous = environment
        defer {
            environment = previous
        }
        do {
            environment = env
            for statement in statements {
                try execute(statement)
            }
        } catch {}
    }
    
    func visitBlock(stmt: BlockStatement) {
        executeBlock(statements: stmt.statements, env: Environment(environment))
    }
    
    func visitExpression(stmt: ExpressionStatement) throws {
        let _ = try evaluate(stmt.expression)
    }
    
    func visitIf(stmt: IfStatement) throws {
        if isTruthy(try evaluate(stmt.condition)) {
            try execute(stmt.thenBranch)
        } else if let elseBranch = stmt.elseBranch {
            try execute(elseBranch)
        }
    }
    
    func visitPrint(stmt: PrintStatement) throws {
        let value = try evaluate(stmt.expression)
        print(stringify(value))
    }
    
    func visitVariable(stmt: VariableStatement) throws {
        var value: Any?
        if let initial = stmt.initializer {
            value = try evaluate(initial)
        }
        environment.define(name: stmt.name.lexeme, value: value)
    }
    
}
