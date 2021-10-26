//
// UnaryExpression.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

struct UnaryExpression: Expr {
    let operation: Token
    let right: Expr

    func accept<V: ExprVisitor, R>(visitor: V) throws -> R where R == V.ExprVisitorReturn {
        return try visitor.visitUnary(expr: self)
    }
}
