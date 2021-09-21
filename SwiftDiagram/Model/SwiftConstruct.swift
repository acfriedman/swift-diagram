//
//  SwiftConstruct.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 9/21/21.
//

import Foundation

enum SwiftConstruct {
    
    enum Error: Swift.Error {
        case invalidConstructName
    }
    
    case classKind
    case structKind
    case protocolKind
    
    static var all: [Self] = {
        return [.classKind, .structKind, .protocolKind]
    }()
    
    static func make(from constructName: String) throws -> Self {
        switch constructName {
        case SwiftConstruct.classKind.stringValue:
            return .classKind
        case SwiftConstruct.structKind.stringValue:
            return .structKind
        case SwiftConstruct.protocolKind.stringValue:
            return .protocolKind
        default:
            throw Error.invalidConstructName
        }
    }
    
    var stringValue: String {
        switch self {
        case .classKind:
            return "class"
        case .structKind:
            return "struct"
        case .protocolKind:
            return "protocol"
        }
    }
}
