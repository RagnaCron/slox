//
// Created by anubis on 25.10.21.
//

import Foundation

struct Token {
    let type: TokenType
    let lexeme: String
    let literal: AnyObject
    let line: Int

    init(_ type: TokenType, _ lexeme: String, _ literal: AnyObject, _ line: Int) {
        self.type = type
        self.lexeme = lexeme
        self.literal = literal
        self.line = line
    }
}
