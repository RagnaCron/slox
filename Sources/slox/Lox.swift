//
// Created by Osiris on 24.10.21.
//

import Foundation

class Lox {
    private var hadError = false

    // The entry point for the Lox interpreter to start its job.
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
        if hadError {
            exit(65)
        }
    }

    private func runPrompt() {
        while true {
            print("> ", separator: "", terminator: "")
            let line = readLine()
            if let l = line {
                run(l)
                hadError = false
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

    private func error(at line: Int, message: String) {
        report(at: line, position: "", message: message)
    }

    private func report(at line: Int, position: String, message: String) {
        print("[line \(line)] Error \(position): \(message)")
        hadError = true
    }
}
