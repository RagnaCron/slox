//
// Visitor.swift
//
//
// Created by RagnaCron on 26.10.21.
//

protocol ExprVisitor {
    associatedtype ExprVisitorReturn

    func visitBinary(expr: BinaryExpression) -> ExprVisitorReturn
    func visitGrouping(expr: GroupingExpression) -> ExprVisitorReturn
    func visitLiteral(expr: LiteralExpression) -> ExprVisitorReturn
    func visitUnary(expr: UnaryExpression) -> ExprVisitorReturn
}
