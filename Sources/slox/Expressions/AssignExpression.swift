//
//  AssignExpression.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

struct AssignExpression: Expression {
    let name: Token
    let value: Expression
    
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionVisitorReturnType {
        return try visitor.visitAssign(expr: self)
    }
}
