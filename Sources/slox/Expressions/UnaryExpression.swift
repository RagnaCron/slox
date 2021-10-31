//
// UnaryExpression.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

final class UnaryExpression: Expression {
    let operation: Token
    let right: Expression

    override func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionVisitorReturnType {
        return try visitor.visitUnary(expr: self)
    }
    
    init(operation: Token, right: Expression) {
        self.operation = operation
        self.right = right
    }
}
