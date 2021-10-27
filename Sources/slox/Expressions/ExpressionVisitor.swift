//
// Visitor.swift
//
//
// Created by RagnaCron on 26.10.21.
//

protocol ExpressionVisitor {
    associatedtype ExpressionVisitorReturnType

    func visitBinary(expr: BinaryExpression) throws -> ExpressionVisitorReturnType
    func visitGrouping(expr: GroupingExpression) throws -> ExpressionVisitorReturnType
    func visitLiteral(expr: LiteralExpression) throws -> ExpressionVisitorReturnType
    func visitUnary(expr: UnaryExpression) throws -> ExpressionVisitorReturnType
}