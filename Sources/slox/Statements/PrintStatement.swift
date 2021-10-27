//
//  PrintStatement.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

struct PrintStatement: Statement {
    let expression: Expression
    
    func accept<V>(visitor: V) throws where V : StatementVisitor {
        try visitor.visitPrint(stmt: self)
    }
}
