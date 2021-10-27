//
// BinaryExpression.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

/**
 The BinaryExpression struct. It implements the Expr Protocol.
 */
struct BinaryExpression: Expression {
    let left: Expression
    let operation: Token
    let right: Expression

    func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionVisitorReturnType {
        return try visitor.visitBinary(expr: self)
    }
}
