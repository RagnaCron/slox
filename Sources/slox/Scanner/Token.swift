//
// Token.swift
//
//
// Created by RagnaCron on 25.10.21.
//

//import Foundation

/**
 The Token struct.
 */
struct Token: CustomStringConvertible {

    let type: TokenType
    let lexeme: String
    let literal: Literal
    let line: Int
    let col: Int

    init(_ type: TokenType, _ lexeme: String, _ literal: Literal, _ line: Int, _ col: Int) {
        self.type = type
        self.lexeme = lexeme
        self.literal = literal
        self.line = line
        self.col = col
    }

    var description: String {
        "\(type): \(lexeme) \(literal)"
    }
}
