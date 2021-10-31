//
//  Resolver.swift
//  
//
//  Created by RagnaCron on 31.10.21.
//

final class Resolver: ExpressionVisitor, StatementVisitor {
    typealias ExpressionVisitorReturnType = Void
    private let interpreter: Interpreter
    private let scopes = Stack()
    
    init(interpreter: Interpreter) {
        self.interpreter = interpreter
    }
    
    func visitAssign(expr: AssignExpression) throws -> ExpressionVisitorReturnType {
        try resolve(expr: expr.value);
        try resolveLocal(expr: expr, name: expr.name)
    }
    
    func visitBinary(expr: BinaryExpression) throws -> ExpressionVisitorReturnType {
        try resolve(expr: expr.left)
        try resolve(expr: expr.right)
    }
    
    func visitCall(expr: CallExpression) throws -> ExpressionVisitorReturnType {
        try resolve(expr: expr.calle)
        for argument in expr.arguments {
            try resolve(expr: argument)
        }
    }
    
    func visitGrouping(expr: GroupingExpression) throws -> ExpressionVisitorReturnType {
        try resolve(expr: expr.expression)
    }
    
    func visitLiteral(expr: LiteralExpression) throws -> ExpressionVisitorReturnType {
        return
    }
    
    func visitLogical(expr: LogicalExpression) throws -> ExpressionVisitorReturnType {
        try resolve(expr: expr.left)
        try resolve(expr: expr.right)
    }
    
    func visitUnary(expr: UnaryExpression) throws -> ExpressionVisitorReturnType {
        try resolve(expr: expr.right)
    }
    
    func visitVariable(expr: VariableExpression) throws -> ExpressionVisitorReturnType {
        if !scopes.isEmpty && scopes.peek()[expr.name.lexeme] == false {
            Lox.error(token: expr.name, message: "Can't read local variable in its own initializer.");
        }
        try resolveLocal(expr: expr, name: expr.name)
    }
        
    func visitBlock(stmt: BlockStatement) throws {
        beginScope()
        try resolve(statements: stmt.statements)
        endScope()
    }
    
    func visitExpression(stmt: ExpressionStatement) throws {
        try resolve(expr: stmt.expression)
    }
    
    func visitFunction(stmt: FunctionStatement) throws {
        declare(name: stmt.name)
        define(name: stmt.name)
        try resolveFun(stmt: stmt)
    }
    
    func visitIf(stmt: IfStatement) throws {
        try resolve(expr: stmt.condition)
        try resolve(stmt: stmt.thenBranch)
        if let elseBranch = stmt.elseBranch {
            try resolve(stmt: elseBranch)
        }
    }
    
    func visitPrint(stmt: PrintStatement) throws {
        try resolve(expr: stmt.expression)
    }
    
    func visitReturn(stmt: ReturnStatement) throws {
        if let value = stmt.value {
            try resolve(expr: value)
        }
    }
    
    func visitVariable(stmt: VariableStatement) throws {
        declare(name: stmt.name)
        if let initial = stmt.initializer {
            try resolve(expr: initial)
        }
        define(name: stmt.name)
    }
    
    func visitWhile(stmt: WhileStatement) throws {
        try resolve(expr: stmt.condition)
        try resolve(stmt: stmt.body)
    }
    
    private func resolve(statements: [Statement]) throws {
        for statement in statements {
            try resolve(stmt: statement)
        }
    }
    
    private func resolve(stmt: Statement) throws {
        try stmt.accept(visitor: self)
    }
    
    private func resolve(expr: Expression) throws {
        let _ = try expr.accept(visitor: self)
    }
    
    private func resolveLocal(expr: Expression, name: Token) throws {
        var index = scopes.count - 1
        while index >= 0 {
            if scopes.get(at: index).keys.contains(name.lexeme) {
                interpreter.resolve(expr: expr, depth: scopes.count - 1 - index)
            }
            index = index - 1
        }
    }
    
    private func resolveFun(stmt: FunctionStatement) throws {
        beginScope()
        for param in stmt.parameters {
            declare(name: param)
            define(name: param)
        }
        try resolve(statements: stmt.body)
        endScope()
    }
    
    private func beginScope() {
        scopes.push(Dictionary<String, Bool>())
    }
    
    private func endScope() {
        let _ = scopes.pop()
    }
    
    private func declare(name: Token) {
        scopes.insertToTopScope(value: false, forKey: name.lexeme)
    }
    
    private func define(name: Token) {
        scopes.insertToTopScope(value: true, forKey: name.lexeme)
    }
}
