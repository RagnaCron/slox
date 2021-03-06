//
// Visitor.swift
//
//
// Created by RagnaCron on 26.10.21.
//

protocol ExpressionVisitor {
    associatedtype ExpressionVisitorReturnType

    func visitAssign(expr: AssignExpression) throws -> ExpressionVisitorReturnType
    func visitBinary(expr: BinaryExpression) throws -> ExpressionVisitorReturnType
    func visitCall(expr: CallExpression) throws -> ExpressionVisitorReturnType
    func visitGet(expr: GetExpression) throws -> ExpressionVisitorReturnType
    func visitGrouping(expr: GroupingExpression) throws -> ExpressionVisitorReturnType
    func visitLiteral(expr: LiteralExpression) throws -> ExpressionVisitorReturnType
    func visitLogical(expr: LogicalExpression) throws -> ExpressionVisitorReturnType
    func visitSelf(expr: SelfExpression) throws -> ExpressionVisitorReturnType
    func visitSet(expr: SetExpression) throws -> ExpressionVisitorReturnType
    func visitUnary(expr: UnaryExpression) throws -> ExpressionVisitorReturnType
    func visitVariable(expr: VariableExpression) throws -> ExpressionVisitorReturnType
}
