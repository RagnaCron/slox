//
//  StatementVisitor.swift
//  
//
//  Created by RagnaCron on 27.10.21.
//

protocol StatementVisitor {
    func visitBlock(stmt: BlockStatement) throws
    func visitExpression(stmt: ExpressionStatement) throws
    func visitFunction(stmt: FunctionStatement) throws
    func visitIf(stmt: IfStatement) throws
    func visitPrint(stmt: PrintStatement) throws
    func visitReturn(stmt: ReturnStatement) throws
    func visitVariable(stmt: VariableStatement) throws
    func visitWhile(stmt: WhileStatement) throws
}
