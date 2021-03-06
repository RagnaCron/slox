//
// Lox.swift
//
//
// Created by RagnaCron on 24.10.21.
//

import Foundation

/**
 The Lox interpreter class.
 */
final class Lox {
    private static var hadError = false
    private static var hadRuntimeError = false
    
    private let interpeter = Interpreter()
    
    /**
     The entry point for the Lox interpreter to start its job.
     */
    public func main() {
        if CommandLine.arguments.count > 2 {
            print("Usage: jlox [script]")
            exit(64)
        } else if CommandLine.arguments.count == 2 {
            runFile(CommandLine.arguments[1])
        } else {
            runPrompt()
        }
    }

    private func runFile(_ filePath: String) {
        var contents: String
        do {
            contents = try String(contentsOfFile: filePath)
        } catch {
            print("Can't read file: \(filePath) \(error)")
            exit(1)
        }
        run(contents)
        if Lox.hadError {
            exit(65)
        }
        if Lox.hadRuntimeError {
            exit(70)
        }
    }

    private func runPrompt() {
        while true {
            print("> ", separator: "", terminator: "")
            let line = readLine(strippingNewline: false)
            if let l = line {
                run(l)
                Lox.hadError = false
            } else {
                break
            }
        }
    }

    private func run(_ source: String) {
        let scanner = Scanner(source)
        let tokens = scanner.scanTokens()
        let parser = Parser(tokens)
        let statements = parser.parse()
        let resolver = Resolver(interpreter: interpeter)
        do {
            try resolver.resolve(statements: statements)
        } catch {
            Lox.hadError = true
        }
        if Lox.hadError {
            return
        }
        interpeter.interpret(statements)
    }

    static func error(at line: Int, inCol col: Int, position: String, message: String) {
        report(at: line, inCol: col, position: position, message: message)
    }

    static func report(at line: Int, inCol col: Int, position: String, message: String) {
        print("[line \(line)][col \(col)] Error \(position): \(message)")
        hadError = true
    }
    
    static func error(token: Token, message: String) {
        if token.type == .EOF {
            report(at: token.line, inCol: token.col, position: "at end", message: message)
        } else {
            report(at: token.line, inCol: token.col, position: "at '\(token.lexeme)'", message: message)
        }
    }
    
    static func runtimeError(_ error: InterpreterRuntimeError) {
        print("[line \(error.token.line)] \(error.message)")
        hadRuntimeError = true
    }
}
