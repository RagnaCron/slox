//
// Parser.swift
//
//
// Created by RagnaCron on 26.10.21.
//

final class Parser {
    typealias Statements = [Statement]
    typealias Tokens = [Token]
    
    private class ParserError: Error {}

    private let tokens: Tokens
    private var current: Int

    init(_ tokens: Tokens) {
        self.tokens = tokens
        current = 0
    }
    
    public func parse() -> Statements {
        var statements = Statements()
        while !isAtEnd() {
            if let statement = declaration() {
                statements.append(statement)
            }
        }
        return statements
    }

    private func expression() throws -> Expression {
        return try assign()
    }
    
    private func declaration() -> Statement? {
        do {
            if match(tokenTypes: .FUN) {
                return try function(kind: "function")
            }
            if match(tokenTypes: .VAR) {
                return try variableDeclaration()
            }
            return try statement()
        } catch {
            synchronize()
            return nil
        }
    }
    
    private func function(kind: String) throws -> Statement {
        let name = try consume(type: .IDENTIFIER, message: "Expect \(kind) name.")
        let _ = try consume(type: .LEFT_PAREN, message: "Expect '(' after \(kind) name.")
        var parameters = [Token]()
        if !check(.RIGHT_PAREN) {
            repeat {
                if parameters.count >= 255 {
                    let _ = error(token: peek(), message: "Can't have more than 255 parameters.")
                }
                parameters.append(try consume(type: .IDENTIFIER, message: "Expect parameter name."))
            } while match(tokenTypes: .COMMA)
        }
        let _ = try consume(type: .RIGHT_PAREN, message: "Expect ')' after parameters.")
        let _ = try consume(type: .LEFT_BRACE, message: "Expect '{' before \(kind) body.")
        let body = try block()
        return FunctionStatement(name: name, parameters: parameters, body: body)
    }
    
    private func variableDeclaration() throws -> Statement {
        let name = try consume(type: .IDENTIFIER, message: "Expect variable name.")
        var initializer: Expression?
        if (match(tokenTypes: .EQUAL)) {
            initializer = try expression()
        }
        let _ = try consume(type: .SEMICOLON, message: "Expect ';' after variable declaration.")
        return VariableStatement(name: name, initializer: initializer)
    }
    
    private func statement() throws -> Statement {
        if match(tokenTypes: .FOR) {
            return try forStatement()
        }
        if match(tokenTypes: .IF) {
            return try ifStatement()
        }
        if match(tokenTypes: .PRINT) {
            return try printStatement()
        }
        if match(tokenTypes: .WHILE) {
            return try whileStatement()
        }
        if match(tokenTypes: .LEFT_BRACE) {
            return try BlockStatement(statements: block())
        }
        return try expressionStatement()
    }
    
    private func forStatement() throws -> Statement {
        let _ = try consume(type: .LEFT_PAREN, message: "Expect '(' after for.")
        var initializer: Statement?
        if match(tokenTypes: .SEMICOLON) {
            initializer = nil
        } else if match(tokenTypes: .VAR) {
            initializer = try variableDeclaration()
        } else {
            initializer = try expressionStatement()
        }
        var condition: Expression?
        if !check(.SEMICOLON) {
            condition = try expression()
        }
        let _ = try consume(type: .SEMICOLON, message: "Expect ';' after loop condition")
        var increment: Expression?
        if !check(.RIGHT_PAREN) {
            increment = try expression()
        }
        let _ = try consume(type: .RIGHT_PAREN, message: "Expect ')' after the clauses.")
        var body = try statement()
        
        if let inc = increment {
            body = BlockStatement(statements: [body, ExpressionStatement(expression: inc)])
        }
        
        if condition == nil {
            condition = LiteralExpression(value: .BOOL(true))
        }
        body = WhileStatement(condition: condition!, body: body)
        
        if let ini = initializer {
            body = BlockStatement(statements: [ini, body])
        }
        
        return body
    }
    
    private func whileStatement() throws -> Statement {
        let _ = try consume(type: .LEFT_PAREN, message: "Expect '(' after while.")
        let condition = try expression()
        let _ = try consume(type: .RIGHT_PAREN, message: "Expect ')' after condition.")
        let body = try statement()
        return WhileStatement(condition: condition, body: body)
    }
    
    private func ifStatement() throws -> Statement {
        let _ = try consume(type: .LEFT_PAREN, message: "Expect '(' after if.")
        let condition = try expression()
        let _ = try consume(type: .RIGHT_PAREN, message: "Expect ')' after if condition")
        let thenBranch = try statement()
        var elseBranch: Statement?
        if match(tokenTypes: .ELSE) {
            elseBranch = try statement()
        }
        return IfStatement(condition: condition, thenBranch: thenBranch, elseBranch: elseBranch)
    }
    
    private func printStatement() throws -> Statement {
        let value = try expression()
        let _ = try consume(type: .SEMICOLON, message: "Expect ';' after value.")
        return PrintStatement(expression: value)
    }
    
    private func expressionStatement() throws -> Statement {
        let expression = try expression()
        let _ = try consume(type: .SEMICOLON, message: "Expect ';' after expression.")
        return ExpressionStatement(expression: expression)
    }
    
    private func block() throws -> Statements {
        var statements = Statements()
        while !check(.RIGHT_BRACE) && !isAtEnd() {
            if let statement = declaration() {
                statements.append(statement)
            }
        }
        let _ = try consume(type: .RIGHT_BRACE, message: "Expect '}' after block.")
        return statements
    }
    
    private func assign() throws -> Expression {
        let expression = try or()
        if match(tokenTypes: .EQUAL) {
            let equals = previous()
            let value = try assign()
            if let expr = expression as? VariableExpression {
                return AssignExpression(name: expr.name, value: value)
            }
            let _ = error(token: equals, message: "Invalid assignment target.")
        }
        return expression
    }
    
    private func or() throws -> Expression {
        var expression = try and()
        while match(tokenTypes: .OR) {
            let operation = previous()
            let right = try and()
            expression = LogicalExpression(left: expression, operation: operation, right: right)
        }
        return expression
    }
    
    private func and() throws -> Expression {
        var expression = try equality()
        while match(tokenTypes: .AND) {
            let operation = previous()
            let right = try equality()
            expression = LogicalExpression(left: expression, operation: operation, right: right)
        }
        return expression
    }

    private func equality() throws -> Expression {
        var expr = try comparison()
        while match(tokenTypes: .BANG_EQUAL, .EQUAL_EQUAL) {
            let op = previous()
            let right = try comparison()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func comparison() throws -> Expression {
        var expr = try term()
        while match(tokenTypes: .GREATER, .GREATER_EQUAL, .LESS, .LESS_EQUAL) {
            let op = previous()
            let right = try term()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func term() throws -> Expression {
        var expr = try factor()
        while match(tokenTypes: .MINUS, .PLUS) {
            let op = previous()
            let right = try factor()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func factor() throws -> Expression {
        var expr = try unary()
        while match(tokenTypes: .SLASH, .STAR) {
            let op = previous()
            let right = try unary()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func unary() throws -> Expression {
        if match(tokenTypes: .BANG, .MINUS) {
            let op = previous()
            let right = try unary()
            return UnaryExpression(operation: op, right: right)
        }
        return try call()
    }
    
    private func call() throws -> Expression {
        var expression = try primary()
        while true {
            if match(tokenTypes: .LEFT_PAREN) {
                expression = try finishCall(callee: expression)
            } else {
                break
            }
        }
        return expression
    }

    private func finishCall(callee: Expression) throws -> Expression {
        var arguments = [Expression]()
        if !check(.RIGHT_PAREN) {
            repeat {
                if (arguments.count >= 255) {
                    let _ = error(token: peek(), message: "Can't have more than 255 arguments.")
                }
                arguments.append(try expression())
            } while match(tokenTypes: .COMMA)
        }
        let paren = try consume(type: .RIGHT_PAREN, message: "Expect ')' after arguments.")
        return CallExpression(calle: callee, parenthesis: paren, arguments: arguments)
    }
    
    private func primary() throws -> Expression {
        if match(tokenTypes: .FALSE) {
            return LiteralExpression(value: .BOOL(false))
        }
        if match(tokenTypes: .TRUE) {
            return LiteralExpression(value: .BOOL(true))
        }
        if match(tokenTypes: .NIL) {
            return LiteralExpression(value: .NIL("nil"))
        }
        if match(tokenTypes: .NUMBER, .STRING) {
            return LiteralExpression(value: previous().literal)
        }
        if match(tokenTypes: .IDENTIFIER) {
            return VariableExpression(name: previous())
        }
        if match(tokenTypes: .LEFT_PAREN) {
            let expr = try expression()
            let _ = try consume(type: .RIGHT_PAREN, message: "Expect ')' after expression.")
            return GroupingExpression(expression: expr)
        }
        throw error(token: peek(), message: "Expect expression.")
    }

    private func match(tokenTypes types: TokenType...) -> Bool {
        for type in types {
            if (check(type)) {
                let _ = advance()
                return true
            }
        }
        return false
    }
    
    private func consume(type: TokenType, message: String) throws -> Token {
        if check(type) {
            return advance()
        }
        throw error(token: peek(), message: message)
    }

    private func check(_ type: TokenType) -> Bool {
        if isAtEnd() {
            return false
        }
        return peek().type == type
    }

    private func advance() -> Token {
        if !isAtEnd() {
            current += 1
        }
        return previous()
    }

    private func isAtEnd() -> Bool {
        return peek().type == .EOF
    }

    private func peek() -> Token {
        return tokens[current]
    }

    private func previous() -> Token {
        return tokens[current - 1]
    }
    
    private func error(token: Token, message: String) -> ParserError {
        Lox.error(token: token, message: message)
        return ParserError()
    }
    
    private func synchronize() {
        let _ = advance()
        while (!isAtEnd()) {
            if previous().type == .SEMICOLON {
                return
            }
            switch peek().type {
            case .CLASS, .FUN, .VAR, .FOR, .IF, .WHILE, .PRINT, .RETURN:
                return
            default:
                let _ = advance()
            }
        }
    }
}
