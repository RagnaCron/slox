//
//  ClassStatement.swift
//  
//
//  Created by RagnaCron on 31.10.21.
//

struct ClassStatement: Statement {
    let name: Token
    let methods: [FunctionStatement]
    
    func accept<V>(visitor: V) throws where V : StatementVisitor {
        try visitor.visitClass(stmt: self)
    }
}
