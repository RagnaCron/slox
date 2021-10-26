//
// Token.swift
//
//
// Created by RagnaCron on 25.10.21.
//

import Foundation

/**
 The Token struct.
 */
struct Token: CustomStringConvertible {

    let type: TokenType
    let lexeme: String
    let literal: Literal
    let line: Int

    init(_ type: TokenType, _ lexeme: String, _ literal: Literal, _ line: Int) {
        self.type = type
        self.lexeme = lexeme
        self.literal = literal
        self.line = line
    }

    var description: String {
        "\(type) \(lexeme) \(literal)"
    }
}
