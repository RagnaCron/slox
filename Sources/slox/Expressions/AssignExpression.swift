//
//  AssignExpression.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

struct AssignExpression: Expression {
    let name: Token
    let value: Expression
    
    func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionVisitorReturnType {
        return try visitor.visitAssign(expr: self)
    }
}
