//
//  CallExpression.swift
//  
//
//  Created by RagnaCron on 29.10.21.
//

struct CallExpression: Expression {
    let calle: Expression
    let parenthesis: Token
    let arguments: [Expression]
    
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionVisitorReturnType {
        return try visitor.visitCall(expr: self)
    }
}
