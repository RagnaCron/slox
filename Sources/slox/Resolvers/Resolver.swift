//
//  Resolver.swift
//  
//
//  Created by RagnaCron on 31.10.21.
//

final class Resolver: ExpressionVisitor, StatementVisitor {
    
    typealias ExpressionVisitorReturnType = Void
    
    private let interpreter: Interpreter
    private let scopes: Stack
    private var currentFunction = FunctionType.NONE
    
    init(interpreter: Interpreter) {
        self.interpreter = interpreter
        self.scopes = Stack()
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
    
    func visitGet(expr: GetExpression) throws -> ExpressionVisitorReturnType {
        try resolve(expr: expr.object)
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
    
    func visitSelf(expr: SelfExpression) throws -> ExpressionVisitorReturnType {
        try resolveLocal(expr: expr, name: expr.keyword)
    }
    
    func visitSet(expr: SetExpression) throws -> ExpressionVisitorReturnType {
        try resolve(expr: expr.value)
        try resolve(expr: expr.object)
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
    
    func visitClass(stmt: ClassStatement) throws {
        declare(name: stmt.name)
        define(name: stmt.name)
        beginScope()
        var scope = scopes.pop()
        scope["self"] = true
        scopes.push(scope)
        for method in stmt.methods {
            try resolveFun(stmt: method, type: .METHOD)
        }
        endScope()
    }
    
    func visitExpression(stmt: ExpressionStatement) throws {
        try resolve(expr: stmt.expression)
    }
    
    func visitFunction(stmt: FunctionStatement) throws {
        declare(name: stmt.name)
        define(name: stmt.name)
        try resolveFun(stmt: stmt, type: .FUNCTION)
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
        if currentFunction == .NONE {
            Lox.error(token: stmt.keyword, message: "Can't return from top-level code.")
        }
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
    
    public func resolve(statements: [Statement]) throws {
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
    
    private func resolveFun(stmt: FunctionStatement, type: FunctionType) throws {
        let enclosingFunType = currentFunction
        currentFunction = type
        
        beginScope()
        for param in stmt.parameters {
            declare(name: param)
            define(name: param)
        }
        try resolve(statements: stmt.body)
        endScope()
        currentFunction = enclosingFunType
    }
    
    private func beginScope() {
        scopes.push(Dictionary<String, Bool>())
    }
    
    private func endScope() {
        let _ = scopes.pop()
    }
    
    private func declare(name: Token) {
        if scopes.isEmpty {
            return
        }
        let scope = scopes.peek()
        if scope.keys.contains(name.lexeme) {
            Lox.error(token: name, message: "Already a variable with this name in this scope.")
        }
        scopes.insertToTopScope(value: false, forKey: name.lexeme)
    }
    
    private func define(name: Token) {
        scopes.insertToTopScope(value: true, forKey: name.lexeme)
    }
}
