//
//  CallExpression.swift
//  
//
//  Created by RagnaCron on 29.10.21.
//

final class CallExpression: Expression {
    let calle: Expression
    let parenthesis: Token
    let arguments: [Expression]
    
    override func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionVisitorReturnType {
        return try visitor.visitCall(expr: self)
    }
    
    init(callee: Expression, parenthesis: Token, arguments: [Expression]) {
        self.calle = callee
        self.parenthesis = parenthesis
        self.arguments = arguments
    }
}
