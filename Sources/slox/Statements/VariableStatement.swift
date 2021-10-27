//
//  VariableStatement.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

struct VariableStatement: Statement {
    let name: Token
    let initializer: Expression?
    
    func accept<V>(visitor: V) throws where V : StatementVisitor {
        try visitor.visitVariable(stmt: self)
    }
}
