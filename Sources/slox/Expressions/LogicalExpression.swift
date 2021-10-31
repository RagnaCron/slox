//
//  LogicalExpression.swift
//  
//
//  Created by RagnaCron on 28.10.21.
//

final class LogicalExpression: Expression {
    let left: Expression
    let operation: Token
    let right: Expression
    
    override func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionVisitorReturnType {
        return try visitor.visitLogical(expr: self)
    }
    
    init(left: Expression, operation: Token, right: Expression) {
        self.left = left
        self.operation = operation
        self.right = right
    }
}
