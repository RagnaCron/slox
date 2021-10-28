//
//  WhileStatement.swift
//  
//
//  Created by Osiris on 28.10.21.
//

struct WhileStatement: Statement {
    let condition: Expression
    let body: Statement
    func accept<V>(visitor: V) throws where V : StatementVisitor {
        try visitor.visitWhile(stmt: self)
    }
}
