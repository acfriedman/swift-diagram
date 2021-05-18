//
//  SwiftNode.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/10/21.
//

import Foundation
import AppKit
import SwiftSyntax

protocol DeclarationNode: CustomDebugStringConvertible {
    var displayColor: NSColor { get }
    var displayWidth: CGFloat { get }
    var displayHeight: CGFloat { get }
    var inheritance: [String] { get }
    var name: String { get }
    var debugDescription: String { get }
}

extension DeclarationNode {
    var displayWidth: CGFloat {
        return 100.0
    }
    var displayHeight: CGFloat {
        return 80.0
    }
    var debugDescription: String {
        """
        name: \(name)
        inheritance: \(inheritance)
        """
    }
}

struct ClassNode: DeclarationNode {
    var displayColor: NSColor { .red }
    var name: String
    private(set) var inheritance: [String]
}

struct StructNode: DeclarationNode {
    
    var displayColor: NSColor { .blue }
    var name: String
    private(set) var inheritance: [String]
}

struct ProtocolNode: DeclarationNode {
    
    var displayColor: NSColor { .purple }
    var name: String
    private(set) var inheritance: [String]
}
