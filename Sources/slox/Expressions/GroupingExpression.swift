//
// GroupingExpression.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

final class GroupingExpression: Expression {
    let expression: Expression

    override func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionVisitorReturnType {
        return try visitor.visitGrouping(expr: self)
    }
    
    init(expression: Expression) {
        self.expression = expression
    }
}
