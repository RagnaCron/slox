//
//  SetExpression.swift
//  
//
//  Created by RagnaCron on 02.11.21.
//

final class SetExpression: Expression {
    let object: Expression
    let name: Token
    let value: Expression
    
    override func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionVisitorReturnType {
        return try visitor.visitSet(expr: self)
    }
    
    init(object: Expression, name: Token, value: Expression) {
        self.object = object
        self.name = name
        self.value = value
    }
}
