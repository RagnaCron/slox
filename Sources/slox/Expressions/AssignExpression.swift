//
//  AssignExpression.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

final class AssignExpression: Expression {
    let name: Token
    let value: Expression
    
    override func accept<V: ExpressionVisitor, R>(visitor: V) throws -> R where R == V.ExpressionVisitorReturnType {
        return try visitor.visitAssign(expr: self)
    }
    
    init(name: Token, value: Expression) {
        self.name = name
        self.value = value
    }
}
