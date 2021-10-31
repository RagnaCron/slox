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
final class BinaryExpression: Expression {
    let left: Expression
    let operation: Token
    let right: Expression

    override func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionVisitorReturnType {
        return try visitor.visitBinary(expr: self)
    }
    
    init(left: Expression, operation: Token, right: Expression) {
        self.left = left
        self.operation = operation
        self.right = right
    }
}
