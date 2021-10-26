//
// Parser.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

final class Parser {
    private class ParserError: Error {}

    private let tokens: [Token]
    private var current: Int

    init(_ tokens: [Token]) {
        self.tokens = tokens
        current = 0
    }
    
    public func parse() -> Expr? {
        do {
            return try expression()
        } catch {
            return nil
        }
    }

    private func expression() throws -> Expr {
        return try equality()
    }

    private func equality() throws -> Expr {
        var expr = try comparison()
        while match([.BANG_EQUAL, .EQUAL_EQUAL]) {
            let op = previous()
            let right = try comparison()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func comparison() throws -> Expr {
        var expr = try term()
        while match([.GREATER, .GREATER_EQUAL, .LESS, .LESS_EQUAL]) {
            let op = previous()
            let right = try term()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func term() throws -> Expr {
        var expr = try factor()
        while match([.MINUS, .PLUS]) {
            let op = previous()
            let right = try factor()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func factor() throws -> Expr {
        var expr = try unary()
        while match([.SLASH, .STAR]) {
            let op = previous()
            let right = try unary()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func unary() throws -> Expr {
        if match([.BANG, .MINUS]) {
            let op = previous()
            let right = try unary()
            return UnaryExpression(operation: op, right: right)
        }
        return try primary()
    }

    private func primary() throws -> Expr {
        if match([.FALSE]) {
            return LiteralExpression(value: .BOOL(false))
        }
        if match([.TRUE]) {
            return LiteralExpression(value: .BOOL(true))
        }
        if match([.NIL]) {
            return LiteralExpression(value: .NIL("nil"))
        }
        if match([.NUMBER, .STRING]) {
            return LiteralExpression(value: previous().literal)
        }
        if match([.LEFT_PAREN]) {
            let expr = try expression()
            let _ = try consume(type: .RIGHT_PAREN, message: "Expect ')' after expression.")
            return GroupingExpression(expression: expr)
        }
        throw error(token: peek(), message: "Expect expression.")
    }

    private func match(_ types: [TokenType]) -> Bool {
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
            case .CLASS:
                return
            case .FUN:
                return
            case .VAR:
                return
            case .FOR:
                return
            case .IF:
                return
            case .WHILE:
                return
            case .PRINT:
                return
            case .RETURN:
                return
            default:
                let _ = advance()
            }
        }
    }
}
