//
// LiteralExpression.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

final class LiteralExpression: Expression {
    let value: Literal

    override func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionVisitorReturnType {
        return try visitor.visitLiteral(expr: self)
    }
    
    init(value: Literal) {
        self.value = value
    }
}
