//
//  File.swift
//  
//
//  Created by Osiris on 25.10.21.
//

import Foundation

class Scanner {
    private var source: String
    private var tokens: [Token]
    private var start: String.Index
    private var current: String.Index
    private var line: Int
    
    init(_ source: String) {
        self.source = source
        self.tokens = Array()
        self.start = source.startIndex
        self.current = source.startIndex
        line = 1
    }
    
    public func scanTokens() -> [Token] {
        while !isAtEnd() {
            start = current
            scanToken()
        }
        tokens.append(Token(.EOF, "", NSNull.self, line))
        return tokens
    }
    
    private func scanToken() {
        let character: String = advance()
        switch character {
        case "(": addToken(type: .LEFT_PAREN)
        case ")": addToken(type: .RIGHT_PAREN)
        case "{": addToken(type: .LEFT_BRACE)
        case "}": addToken(type: .RIGHT_BRACE)
        case ",": addToken(type: .COMMA)
        case ".": addToken(type: .DOT)
        case "-": addToken(type: .MINUS)
        case "+": addToken(type: .PLUS)
        case ";": addToken(type: .SEMICOLON)
        case "*": addToken(type: .STAR)
        case "!":
            addToken(type: match("=") ? .BANG_EQUAL : .BANG)
        case "=":
            addToken(type: match("=") ? .EQUAL_EQUAL : .EQUAL)
        case "<":
            addToken(type: match("=") ? .LESS_EQUAL : .LESS)
        case ">":
            addToken(type: match("=") ? .GREATER_EQUAL : .GREATER)
        case "/":
            if match(character) {
                while peek() != "\n" && !isAtEnd() {
                    let _ = advance()
                }
            } else {
                addToken(type: .SLASH)
            }
        case " ": break
        case "\r": break
        case "\t": break
        case "\n":
            line += 1
        default:
            Lox.error(at: line, message: "Unexpected character.")
        }
    }
    
    private func match(_ character: String) -> Bool {
        if isAtEnd(){
            return false
            
        }
        if String(source[current]) != character {
            return false
        }
        current = source.index(after: current)
        return true
    }
    
    private func peek() -> String {
        if isAtEnd() {
            return "\0"
        }
        return String(source[current])
    }
    
    private func isAtEnd() -> Bool {
        return current >= source.endIndex
    }
    
    private func addToken(type: TokenType) {
        addToken(type: type, literal: NSNull.self)
    }
    
    private func addToken(type: TokenType, literal: Any) {
        let text = String(source[start..<current])
        tokens.append(Token(type, text, literal, line))
    }
    
    private func advance() -> String {
        let char = String(source[current])
        current = source.index(after: current)
        return char
    }
}
