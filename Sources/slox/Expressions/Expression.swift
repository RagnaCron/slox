//
// Expr.swift
//
//
// Created by RagnaCron on 26.10.21.
//

/**
 The Expression (Expr) Class  is the base for all Expressions in Lox.
 */
class Expression: Equatable, Hashable {
    func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionVisitorReturnType {
        fatalError("You have to implement a subclass...!!!")
    }
    
    static func == (lhs: Expression, rhs: Expression) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
