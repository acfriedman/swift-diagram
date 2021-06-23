//
//  SwiftViewer.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 4/29/21.
//

import Foundation
import AppKit
import SwiftSyntax




struct SwiftViewer {
    
    private static let acceptableFileTypes: Set<String> = ["swift"]
    
    static func parse(_ urls: [URL]) throws -> [DeclarationNode] {
        
        urls.filter { acceptableFileTypes.contains($0.pathExtension) }
            .compactMap { try? parse(String(contentsOf: $0)) }
            .flatMap { $0 }
    }
    
    static func parse(_ string: String) throws -> [DeclarationNode] {
            
        let sourceFileSyntax = try SyntaxParser.parse(source: string)
        let declCollector = DeclarationCollector()
        declCollector.walk(sourceFileSyntax)
        return constructChildRelationships(for: declCollector.all)
    }
    
    private static func constructChildRelationships(for nodes: [DeclarationNode]) -> [DeclarationNode] {
        
        var map = nodes.reduce(into: [String: DeclarationNode](), { $0[$1.name] = $1 })
        
        nodes.forEach { node in
            node.inheritance.forEach { parent in
                map[parent]?.add(node)
            }
        }
        
        return Array(map.values)
    }
}

extension SwiftViewer {
    enum Error: Swift.Error {
        case couldNotFindFile
        case invalidStringURL
        case unacceptableFileTypeExtension
    }
}

extension SwiftViewer.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidStringURL:
            return "The string value passed could not be converted to URL."
        case .couldNotFindFile:
            return "Could not find file, or file is not of swift type"
        case .unacceptableFileTypeExtension:
            return "Attempted to parse a file type other than swift"
        }
    }
}

class DeclarationCollector: SyntaxVisitor {
    
    var classes: [DeclarationNode] = []
    
    var structs: [DeclarationNode] = []
    
    var protocols: [DeclarationNode] = []
    
    /// All `DeclarationNode`s in the order of Class --> Struct --> Protocol
    var all: [DeclarationNode] {
        return classes + structs + protocols
    }
    
    override func visitPost(_ node: ClassDeclSyntax) {
        let name = node.identifier.text
        let inheritance = node.inheritanceClause?
            .inheritedTypeCollection
            .map { $0.typeName.withoutTrivia().description
        } ?? []
        classes.append(ClassNode(name: name, inheritance: inheritance))
    }
    
    override func visitPost(_ node: ProtocolDeclSyntax) {
        let name = node.identifier.text
        let inheritance = node.inheritanceClause?
            .inheritedTypeCollection
            .map { $0.typeName.withoutTrivia().description
        } ?? []
        protocols.append(ProtocolNode(name: name, inheritance: inheritance))
    }
    
    override func visitPost(_ node: StructDeclSyntax) {
        let name = node.identifier.text
        let inheritance = node.inheritanceClause?
            .inheritedTypeCollection
            .map { $0.typeName.withoutTrivia().description
        } ?? []
        structs.append(StructNode(name: name, inheritance: inheritance))
    }
}
