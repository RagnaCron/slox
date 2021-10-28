//
//  BlockStatement.swift
//  
//
//  Created by Osiris on 28.10.21.
//

struct BlockStatement: Statement {
    let statements: [Statement]
    func accept<V>(visitor: V) throws where V : StatementVisitor {
        try visitor.visitBlock(stmt: self)
    }
}
