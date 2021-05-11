//
//  SwiftNode.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/10/21.
//

import Foundation
import AppKit
import SwiftSyntax

struct SyntaxNodeFactory {
    
    enum Error: Swift.Error {
        case undesiredNode
    }
    
    static func make(from tokenSyntax: TokenSyntax) throws -> SyntaxNode {
        guard let declarationName = tokenSyntax.nextToken?.text else {
            throw Error.undesiredNode
        }
        
        switch tokenSyntax.tokenKind {
        case .structKeyword:
            return StructNode(name: declarationName)
        case .classKeyword:
            return ClassNode(name: declarationName)
        case .protocolKeyword:
            return ProtocolNode(name: declarationName)
        default:
            throw Error.undesiredNode
        }
    }
}

protocol SyntaxNode {
    var displayColor: NSColor { get }
    var displayWidth: CGFloat { get }
    var displayHeight: CGFloat { get }
    var name: String { get }
}

extension SyntaxNode {
    var displayWidth: CGFloat {
        return 100.0
    }
    var displayHeight: CGFloat {
        return 80.0
    }
}

struct ClassNode: SyntaxNode {
    
    var displayColor: NSColor { .red }
    var name: String
}

struct StructNode: SyntaxNode {
    
    var displayColor: NSColor { .blue }
    var name: String
}

struct ProtocolNode: SyntaxNode {
    
    var displayColor: NSColor { .purple }
    var name: String
}
