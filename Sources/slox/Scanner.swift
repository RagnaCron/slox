//
//  File.swift
//  
//
//  Created by Osiris on 25.10.21.
//

import Foundation

class Scanner {
    private var source: [Character]
    private var tokens: [Token]
    private var start: Int
    private var current: Int
    private var line: Int
    
    init(_ source: String) {
        self.source = source.map({$0})
//        print(self.source)
        self.tokens = Array()
        self.start = 0
        self.current = 0
        line = 1
    }
    
    public func scanTokens() -> [Token] {
        while !isAtEnd() {
            start = current
            scanToken()
        }
        tokens.append(Token(.EOF, "", .NONE, line))
        return tokens
    }
    
    private func scanToken() {
        let character = advance()
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
        case "\"":
            addStringToken()
        default:
            Lox.error(at: line, in: start, position: "", message: "Unexpected character: '\(character)'")
        }
    }
    
    private func addStringToken() {
        while peek() != "\"" && !isAtEnd() {
            if peek() == "\n" {
                line += 1
            }
            let _ = advance()
        }
        if isAtEnd() {
            Lox.error(at: line, in: current, position: "", message: "Unterminated String.")
            return
        }
        // The closing ".
        let _ = advance()

        // Trim the surrounding quoats.
        let value = String(source[(start + 1)..<(current - 1)])
        addToken(type: .STRING, literal: .STRING(value))
    }
    
    private func match(_ character: Character) -> Bool {
        if isAtEnd(){
            return false
            
        }
        if source[current] != character {
            return false
        }
        current = source.index(after: current)
        return true
    }
    
    private func peek() -> Character {
        if isAtEnd() {
            return Character("\0")
        }
        return source[current]
    }
    
    private func isAtEnd() -> Bool {
        return current >= source.endIndex
    }
    
    private func addToken(type: TokenType) {
        addToken(type: type, literal: .NONE)
    }
    
    private func addToken(type: TokenType, literal: Literal) {
        let text = String(source[start..<current])
        tokens.append(Token(type, text, literal, line))
    }
    
    private func advance() -> Character {
        let char = source[current]
        current += 1
        return char
    }
}
