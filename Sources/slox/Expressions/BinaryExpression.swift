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
struct BinaryExpression: Expr {
    let left: Expr
    let operation: Token
    let right: Expr

    func accept<V: ExprVisitor, R>(visitor: V) throws -> R where R == V.ExprVisitorReturn {
        return try visitor.visitBinary(expr: self)
    }
}
