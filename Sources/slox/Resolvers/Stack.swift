//
//  Stack.swift
//  
//
//  Created by RagnaCron on 31.10.21.
//

final class Stack {
    private var stack: Array<Dictionary<String, Bool>>
    
    init() {
        self.stack = Array<Dictionary<String, Bool>>()
    }
    
    var count: Int {
        return stack.count
    }
    
    var isEmpty: Bool {
        return stack.isEmpty
    }
    
    func pop() -> Dictionary<String, Bool> {
        return stack.removeLast()
    }
    
    func push(_ value: Dictionary<String, Bool>) {
        stack.append(value)
    }
    
    func insertToTopScope(value: Bool, forKey key: String) {
        if stack.isEmpty {
            return 
        }
        stack[stack.count - 1].updateValue(value, forKey: key)
    }
    
    func peek() -> Dictionary<String, Bool> {
        return stack[stack.count - 1]
    }
    
    func get(at: Int) -> Dictionary<String, Bool>{
        return stack[at]
    }
}
