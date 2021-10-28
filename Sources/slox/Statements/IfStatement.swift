//
//  IfStatement.swift
//  
//
//  Created by Osiris on 28.10.21.
//

struct IfStatement: Statement {
    let condition: Expression
    let thenBranch: Statement
    let elseBranch: Statement?
    
    func accept<V>(visitor: V) throws where V : StatementVisitor {
        try visitor.visitIf(stmt: self)
    }
}
