//
//  ReturnStatement.swift
//  
//
//  Created by RagnaCron on 29.10.21.
//

struct ReturnStatement: Statement {
    let keyword: Token
    let value: Expression?
    
    func accept<V>(visitor: V) throws where V : StatementVisitor {
        try visitor.visitReturn(stmt: self)
    }
}
