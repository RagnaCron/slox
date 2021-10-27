//
// LiteralExpression.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

struct LiteralExpression: Expression {
    let value: Literal

    func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionVisitorReturnType {
        return try visitor.visitLiteral(expr: self)
    }
}
