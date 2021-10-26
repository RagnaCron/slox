//
// Created by odin on 26.10.21.
//

import Foundation

class AstPrinter: ExprVisitor {
    typealias ExprVisitorReturn = String

    public func print(expr: Expr) -> String {
        return expr.accept(visitor: self)
    }

    public func visitBinary(expr: BinaryExpression) -> ExprVisitorReturn {
        return parenthesize(name: expr.operation.lexeme, exprs: [expr.left, expr.right])
    }

    public func visitGrouping(expr: GroupingExpression) -> ExprVisitorReturn {
        return parenthesize(name: "group", exprs: [expr.expression])
    }

    public func visitLiteral(expr: LiteralExpression) -> ExprVisitorReturn {
        return expr.value.description
    }

    public func visitUnary(expr: UnaryExpression) -> ExprVisitorReturn{
        return parenthesize(name: expr.operation.lexeme, exprs: [expr.right])
    }

    private func parenthesize(name: String, exprs: [Expr]) -> String {
        var builder = ""
        builder.append("(" + name)
        for expr in exprs {
            builder.append(" ")
            builder.append(expr.accept(visitor: self))
        }
        builder.append(")")
        return builder
    }
}
