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
        return urls.compactMap { try? parse($0) }.flatMap { $0 }
    }
    
    static func parse(_ url: URL) throws -> [DeclarationNode] {
        
        guard acceptableFileTypes.contains(url.pathExtension) else {
            throw Error.unacceptableFileTypeExtension
        }
        
        let sourceFileSyntax = try SyntaxParser.parse(url)
        let declCollector = DeclarationCollector()
        declCollector.walk(sourceFileSyntax)
        declCollector.all.forEach { print($0.debugDescription + "\n") }
        
        return declCollector.all
    }
}

extension SwiftViewer {
    enum Error: Swift.Error {
        case couldNotFindFile
        case unacceptableFileTypeExtension
    }
}
extension SwiftViewer.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
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
