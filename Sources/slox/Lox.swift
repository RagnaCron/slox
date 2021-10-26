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
    }

    private func runPrompt() {
        while true {
            print("> ", separator: "", terminator: "")
            let line = readLine(strippingNewline: false)
//            let line = readLine()
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

        for token in tokens {
            print(token)
        }
    }

    static func error(at line: Int, inCol col: Int, position: String, message: String) {
        report(at: line, inCol: col, position: position, message: message)
    }

    static func report(at line: Int, inCol col: Int, position: String, message: String) {
        print("[line \(line)][col \(col)] Error \(position): \(message)")
        hadError = true
    }
}
