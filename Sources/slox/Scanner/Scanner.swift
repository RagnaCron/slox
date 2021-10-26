//
// Scanner.swift
//  
//
// Created by RagnaCron on 25.10.21.
//

//import Foundation

/**
 Tha Scanner class.
 */
final class Scanner {
    private static let keywords: [String : TokenType] = [
        "and" : .AND,
        "class" : .CLASS,
        "else" : .ELSE,
        "false" : .FALSE,
        "for" : .FOR,
        "fun" : .FUN,
        "if" : .IF,
        "nil" : .NIL,
        "or" : .OR,
        "print" : .PRINT,
        "return" : .RETURN,
        "super" : .SUPER,
        "self" : .SELF,
        "true" : .TRUE,
        "var" : .VAR,
        "while" : .WHILE
    ]
    private var source: [Character]
    private var tokens: [Token]
    private var start: Int
    private var current: Int
    private var line: Int
    
    init(_ source: String) {
        self.source = source.map({$0})
        self.tokens = Array()
        self.start = 0
        self.current = 0
        self.line = 1
    }
    
    public func scanTokens() -> [Token] {
        while !isAtEnd() {
            start = current
            scanToken()
        }
        tokens.append(Token(.EOF, "", .NONE, line, current))
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
        case "!": addToken(type: match("=") ? .BANG_EQUAL : .BANG)
        case "=": addToken(type: match("=") ? .EQUAL_EQUAL : .EQUAL)
        case "<": addToken(type: match("=") ? .LESS_EQUAL : .LESS)
        case ">": addToken(type: match("=") ? .GREATER_EQUAL : .GREATER)
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
        case "\n": line += 1
        case "\"": addStringToken()
        default:
            if isDigit(character) {
                addNumberToken()
            } else if isAlpha(character) {
                addIdentifierToken()
            } else {
                Lox.error(at: line, inCol: start, position: "", message: "Unexpected character: '\(character)'")
            }
        }
    }
    
    private func addIdentifierToken() {
        while isAlphaNumberic(peek()) {
            let _ = advance()
        }
        let text = String(source[start..<current])
        if let type = Scanner.keywords[text] {
            if (text == "true" || text == "false") {
                addToken(type: type, literal: .BOOL(text))
            } else if text == "nil" {
                addToken(type: type, literal: .NIL(text))
            } else {
                addToken(type: type)
            }
        } else {
            addToken(type: .IDENTIFIER)
        }
    }
    
    private func addNumberToken() {
        func digit() {
            while isDigit(peek()) {
                let _ = advance()
            }
        }
        digit()
        // Look for a fracional part.
        if peek() == "." && isDigit(peekNext()) {
            // Consume "."
            let _ = advance()
            digit()
        }
        if let digit = Double(String(source[start..<current])) {
            addToken(type: .NUMBER, literal: .NUMBER(digit))
        } else {
            Lox.error(at: line, inCol: current, position: "", message: "Could not convert String to Number")
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
            Lox.error(at: line, inCol: current, position: "", message: "Unterminated String.")
            return
        }
        // The closing "
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
    
    private func peekNext() -> Character {
        if (current + 1) >= source.endIndex {
            return "\0"
        }
        return source[current + 1]
    }
    
    private func isAlphaNumberic(_ char: Character) -> Bool {
        return isAlpha(char) || isDigit(char)
    }
    
    private func isAlpha(_ char: Character) -> Bool {
        return (char >= "a" && char <= "z")
        || (char >= "A" && char <= "Z")
        || (char == "_")
    }
    
    private func isDigit(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }
    
    private func isAtEnd() -> Bool {
        return current >= source.endIndex
    }
    
    private func addToken(type: TokenType) {
        addToken(type: type, literal: .NONE)
    }
    
    private func addToken(type: TokenType, literal: Literal) {
        let text = String(source[start..<current])
        tokens.append(Token(type, text, literal, line, current))
    }
    
    private func advance() -> Character {
        let char = source[current]
        current += 1
        return char
    }
}
