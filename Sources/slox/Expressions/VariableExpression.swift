//
//  VariableExpression.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

struct VariableExpression: Expression {
    let name: Token
    
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionVisitorReturnType {
        return try visitor.visitVariable(expr: self)
    }
}
