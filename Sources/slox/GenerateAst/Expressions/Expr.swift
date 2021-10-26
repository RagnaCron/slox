//
// Expr.swift
//
//
// Created by RagnaCron on 26.10.21.
//

/**
 The Expression (Expr) Protocol is the base for all Expressions in Lox.
 */
protocol Expr {
    func accept<V: ExprVisitor, R>(visitor: V) -> R where R == V.ExprVisitorReturn
}
