//
//  GetExpression.swift
//  
//
//  Created by RagnaCron on 31.10.21.
//

final class GetExpression: Expression {
    let object: Expression
    let name: Token
    
    override func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionVisitorReturnType {
        return try visitor.visitGet(expr: self)
    }
    
    init(object: Expression, name: Token) {
        self.object = object
        self.name = name
    }
}
