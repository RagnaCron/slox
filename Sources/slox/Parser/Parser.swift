//
// Parser.swift
//
//
// Created by RagnaCron on 26.10.21.
//

//import Foundation

final class Parser {
    private let tokens: [Token]
    private var current: Int

    init(_ tokens: [Token]) {
        self.tokens = tokens
        current = 0
    }

    private func expression() -> Expr {
        return equality()
    }

    private func equality() -> Expr {
        var expr = comparison()
        while match([.BANG_EQUAL, .EQUAL_EQUAL]) {
            let op = previous()
            let right = comparison()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func comparison() -> Expr {
        var expr = term()
        while match([.GREATER, .GREATER_EQUAL, .LESS, .LESS_EQUAL]) {
            let op = previous()
            let right = term()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func term() -> Expr {
        var expr = factor()
        while match([.MINUS, .PLUS]) {
            let op = previous()
            let right = factor()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func factor() -> Expr {
        var expr = unary()
        while match([.SLASH, .STAR]) {
            let op = previous()
            let right = unary()
            expr = BinaryExpression(left: expr, operation: op, right: right)
        }
        return expr
    }

    private func unary() -> Expr {
        if match([.BANG, .MINUS]) {
            let op = previous()
            let right = unary()
            return UnaryExpression(operation: op, right: right)
        }
        return primary()
    }

    private func primary() -> Expr? {
//        if match([.FALSE]) {
//            return LiteralExpression(value: .FALSE)
//        }
//        if match([.TRUE]) {
//            return LiteralExpression(value: .TRUE)
//        }
//        if match([.NIL]) {
//            return LiteralExpression(value: .NIL)
//        }
        if match([.NUMBER, .STRING]) {
            return LiteralExpression(value: previous().literal)
        }
        if match([.LEFT_PAREN]) {
            let expr = expression()
//            consume(.RIGHT_PAREN, "Expect ')' after expression.")
            return GroupingExpression(expression: expr)
        }
        return nil
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
}
