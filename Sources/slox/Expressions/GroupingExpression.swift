//
// GroupingExpression.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

struct GroupingExpression: Expression {
    let expression: Expression

    func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionVisitorReturnType {
        return try visitor.visitGrouping(expr: self)
    }
}
