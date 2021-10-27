//
//  Statement.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

protocol Statement {
    func accept<V>(visitor: V) throws where V : StatementVisitor
}
