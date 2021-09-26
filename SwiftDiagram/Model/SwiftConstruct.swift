//
//  SwiftConstruct.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 9/21/21.
//

import Foundation
import AppKit

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
        switch constructName.lowercased() {
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
    
    var color: NSColor {
        switch self {
        case .classKind:
            return .red
        case .structKind:
            return .blue
        case .protocolKind:
            return .purple
        }
    }
}
