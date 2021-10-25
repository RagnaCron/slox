//
//  File.swift
//  
//
//  Created by Osiris on 25.10.21.
//

import Foundation

enum Literal: CustomStringConvertible {
    case STRING(String)
    case NUMBER(Double)
    case NONE
    
    var description: String {
        switch self {
        case .STRING(let value):
            return "String \(value)"
        case .NUMBER(let value):
            return "Number \(value)"
        case .NONE:
            return ""
        }
    }
}
