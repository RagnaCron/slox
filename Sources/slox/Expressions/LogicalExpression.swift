//
//  LogicalExpression.swift
//  
//
//  Created by RagnaCron on 28.10.21.
//

struct LogicalExpression: Expression {
    let left: Expression
    let operation: Token
    let right: Expression
    
    func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionVisitorReturnType {
        return try visitor.visitLogical(expr: self)
    }
}
