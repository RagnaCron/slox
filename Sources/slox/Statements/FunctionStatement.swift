//
//  FunctionStatement.swift
//  
//
//  Created by RagnaCron on 29.10.21.
//

struct FunctionStatement: Statement {
    let name: Token
    let parameters: [Token]
    let body: [Statement]
    
    func accept<V>(visitor: V) throws where V : StatementVisitor {
        try visitor.visitFunction(stmt: self)
    }
}
