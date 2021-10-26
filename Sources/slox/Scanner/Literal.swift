//
// Literal.swift
//  
//
// Created by RagnaCron on 25.10.21.
//

//import Foundation

/**
 The LiteralToken enum is used to help in the moment where a literal value has to be saved.
 This is the case for String or Number values.
 
 The LiteralToken enum confirmes to the CustomStringConvertible Protocol. The String representation of
 each enum case is given here:
 - STRING(String) -> "String (passed in value)"
 - NUMBER(Double) -> "Number (passed in value)"
 - NONE -> returns an empty string
 */
enum Literal: CustomStringConvertible {
    case STRING(String)
    case NUMBER(Double)
    case NONE
    
    var description: String {
        switch self {
        case .STRING(let value):
            return "String '\(value)'"
        case .NUMBER(let value):
            return "Number '\(value)'"
        case .NONE:
            return ""
        }
    }

    func toString() -> String {
        switch self {
        case .STRING(let value):
            return "\(value)"
        case .NUMBER(let value):
            return "\(value)"
        case .NONE:
            return ""
        }
    }
}
