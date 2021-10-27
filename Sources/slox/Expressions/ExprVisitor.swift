//
// Visitor.swift
//
//
// Created by RagnaCron on 26.10.21.
//

protocol ExprVisitor {
    associatedtype ExprVisitorReturn

    func visitBinary(expr: BinaryExpression) throws -> ExprVisitorReturn
    func visitGrouping(expr: GroupingExpression) throws -> ExprVisitorReturn
    func visitLiteral(expr: LiteralExpression) throws -> ExprVisitorReturn
    func visitUnary(expr: UnaryExpression) throws -> ExprVisitorReturn
}
