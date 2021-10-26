//
// LiteralExpression.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

struct LiteralExpression: Expr {
    let value: Literal

    func accept<V: ExprVisitor, R>(visitor: V) -> R where R == V.ExprVisitorReturn {
        return visitor.visitLiteral(expr: self)
    }
}
