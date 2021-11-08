//
//  SelfExpression.swift
//  
//
//  Created by RagnaCron on 04.11.21.
//

final class SelfExpression: Expression {
    let keyword: Token
    
    override func accept<V, R>(visitor: V) throws -> R where V : ExpressionVisitor, R == V.ExpressionVisitorReturnType {
        return try visitor.visitSelf(expr: self)
    }
    
    init(keyword: Token) {
        self.keyword = keyword
    }
}
