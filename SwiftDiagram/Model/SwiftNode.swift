//
//  SwiftNode.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/10/21.
//

import Foundation
import AppKit
import SwiftSyntax

// We can make this protocol equatable using the follow guide on type erasure
// https://stackoverflow.com/a/46719045

protocol DeclarationNode: CustomDebugStringConvertible {
    
    var name: String { get }
    var displayColor: NSColor { get }
    
    var inheritance: Set<String> { get }
    var children: Set<String> { get }
    var usage: Set<String> { get }
    
    mutating func add(child: DeclarationNode)
    mutating func add(use: String)
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
        usage: \(usage)
        """
    }
}

struct ClassNode: DeclarationNode {
    
    var displayColor: NSColor { .red }
    var name: String
    private(set) var inheritance: Set<String> = []
    private(set) var children: Set<String> = []
    private(set) var usage: Set<String> = []
    
    mutating func add(child: DeclarationNode) {
        children.insert(child.name)
    }
    
    mutating func add(use: String) {
        usage.insert(use)
    }
}

struct StructNode: DeclarationNode {
    
    var displayColor: NSColor { .blue }
    var name: String
    private(set) var inheritance: Set<String> = []
    private(set) var children: Set<String> = []
    private(set) var usage: Set<String> = []
    
    mutating func add(child: DeclarationNode) {
        children.insert(child.name)
    }
    
    mutating func add(use: String) {
        usage.insert(use)
    }
}

struct ProtocolNode: DeclarationNode {
    
    var displayColor: NSColor { .purple }
    var name: String
    private(set) var inheritance: Set<String> = []
    private(set) var children: Set<String> = []
    private(set) var usage: Set<String> = []
    
    mutating func add(child: DeclarationNode) {
        children.insert(child.name)
    }
    
    mutating func add(use: String) {
        usage.insert(use)
    }
}
