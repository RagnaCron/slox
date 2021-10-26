//
// GroupingExpression.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

struct GroupingExpression: Expr {
    let expression: Expr

    func accept<V: ExprVisitor, R>(visitor: V) -> R where R == V.ExprVisitorReturn {
        return visitor.visitGrouping(expr: self)
    }
}
