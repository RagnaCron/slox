//
//  StatementVisitor.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

protocol StatementVisitor {
    func visitExpression(stmt: ExpressionStatement) throws
    func visitPrint(stmt: PrintStatement) throws
    func visitVariable(stmt: VariableStatement) throws
}