//
// Created by Osiris on 24.10.21.
//

import Foundation

class Lox {
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
    }

    private func runPrompt() {
        while true {
            print("> ", separator: "", terminator: "")
            let line = readLine() ?? ""
            if line == "" {
                break
            }
            run(line)
        }
    }

    private func run(_ content: String) {
        print(content)
    }
}
