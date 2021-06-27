//
//  SwiftNode.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/10/21.
//

import Foundation
import AppKit
import SwiftSyntax

// We can make this protocol equatable using the follow guide
// https://stackoverflow.com/a/46719045

protocol DeclarationNode: CustomDebugStringConvertible {
    
    var name: String { get }
    var displayColor: NSColor { get }
    
    var inheritance: [String] { get }
    var children: [String] { get }
    
    mutating func add(_ child: DeclarationNode)
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
        children: \(children)
        """
    }
}

struct ClassNode: DeclarationNode {
    var displayColor: NSColor { .red }
    var name: String
    private(set) var inheritance: [String]
    private(set) var children: [String] = []
    
    mutating func add(_ child: DeclarationNode) {
        children.append(child.name)
    }
}

struct StructNode: DeclarationNode {
    
    var displayColor: NSColor { .blue }
    var name: String
    private(set) var inheritance: [String]
    private(set) var children: [String] = []
    
    mutating func add(_ child: DeclarationNode) {
        children.append(child.name)
    }
}

struct ProtocolNode: DeclarationNode {
    
    var displayColor: NSColor { .purple }
    var name: String
    private(set) var inheritance: [String]
    private(set) var children: [String] = []
    
    mutating func add(_ child: DeclarationNode) {
        children.append(child.name)
    }
}
