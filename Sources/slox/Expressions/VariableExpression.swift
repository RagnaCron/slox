//
//  VariableExpression.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

final class VariableExpression: Expression {
    let name: Token
    
    override func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionVisitorReturnType {
        return try visitor.visitVariable(expr: self)
    }
    
    init(name: Token) {
        self.name = name
    }
}
