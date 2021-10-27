//
// UnaryExpression.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

struct UnaryExpression: Expression {
    let operation: Token
    let right: Expression

    func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionVisitorReturnType {
        return try visitor.visitUnary(expr: self)
    }
}
