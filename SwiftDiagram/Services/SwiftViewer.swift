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
        
        let filteredURLs = urls.filter { acceptableFileTypes.contains($0.pathExtension) }
        
        var declSyntax: [DeclSyntaxProtocol] = []
        var declNodeIds: Set<String> = []
        for url in filteredURLs {
            let sourceFileSyntax = try SyntaxParser.parse(url)
            let declCollector = DeclarationCollector()
            declCollector.walk(sourceFileSyntax)
            declSyntax += declCollector.allDeclSyntax
            declNodeIds.formUnion(declCollector.allNodeIds)
        }
        
        var nodes: [DeclarationNode] = []
        var extensions: [(String, [String])] = []
        
        for syntax in declSyntax {
            
            switch syntax {
            case let syntax as StructDeclSyntax:
                let name = syntax.identifier.text
                let inheritance = syntax.inheritanceClause?
                    .inheritedTypeCollection
                    .map { $0.typeName.withoutTrivia().description
                    } ?? []
                let structNode = StructNode(name: name, inheritance: Set(inheritance))
                let typeCollector = TypeUsageCollector(declNode: structNode, allDeclNodes: declNodeIds)
                typeCollector.walk(syntax)
                nodes += [typeCollector.declNode]
                
            case let syntax as ProtocolDeclSyntax:
                let name = syntax.identifier.text
                let inheritance = syntax.inheritanceClause?
                    .inheritedTypeCollection
                    .map { $0.typeName.withoutTrivia().description
                    } ?? []
                let protocolNode = ProtocolNode(name: name, inheritance: Set(inheritance))
                let typeCollector = TypeUsageCollector(declNode: protocolNode, allDeclNodes: declNodeIds)
                typeCollector.walk(syntax)
                nodes += [typeCollector.declNode]
                
            case let syntax as ClassDeclSyntax:
                let name = syntax.identifier.text
                let inheritance = syntax.inheritanceClause?
                    .inheritedTypeCollection
                    .map { $0.typeName.withoutTrivia().description
                    } ?? []
                
                let classNode = ClassNode(name: name, inheritance: Set(inheritance))
                let typeCollector = TypeUsageCollector(declNode: classNode, allDeclNodes: declNodeIds)
                typeCollector.walk(syntax)
                nodes += [typeCollector.declNode]
                
            case let syntax as ExtensionDeclSyntax:
                
                let inheritance = syntax.inheritanceClause?
                    .inheritedTypeCollection
                    .map { $0.typeName.withoutTrivia().description
                    } ?? []
                extensions += [(syntax.extendedType.description, inheritance)]
                
            default:
                break
            }
        }
        
        nodes = constructParentRelationships(for: nodes, from: extensions)
        let childRelationshipNodes = constructChildRelationships(for: nodes)
        let usedByRelationshipNodes = constructUsedByRelationships(for: childRelationshipNodes)
        return usedByRelationshipNodes
    }
    
    private static func constructChildRelationships(for nodes: [DeclarationNode]) -> [DeclarationNode] {
        
        var map = nodes.reduce(into: [String: DeclarationNode](), { $0[$1.name] = $1 })
        
        nodes.forEach { node in
            node.inheritance.forEach { parent in
                map[parent]?.add(child: node)
            }
        }
        
        return Array(map.values)
    }
    
    private static func constructParentRelationships(for nodes: [DeclarationNode], from extensions: [(String, [String])]) -> [DeclarationNode] {
        
        var map = nodes.reduce(into: [String: DeclarationNode](), { $0[$1.name] = $1 })
        extensions.forEach { ext in
            map[ext.0]?.add(parents: ext.1)
        }
        
        return Array(map.values)
    }
    
    private static func constructUsedByRelationships(for nodes: [DeclarationNode]) -> [DeclarationNode] {
        
        var map = nodes.reduce(into: [String: DeclarationNode](), { $0[$1.name] = $1 })
        
        nodes.forEach { node in
            node.usage.forEach { parent in
                map[parent]?.add(usedBy: node.name)
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

    var allDeclSyntax: [DeclSyntaxProtocol] = []
    
    var allNodeIds: Set<String> = []
    
    override func visitPost(_ node: ClassDeclSyntax) {
        allNodeIds.insert(node.identifier.text)
        allDeclSyntax.append(node)
    }
    
    override func visitPost(_ node: ProtocolDeclSyntax) {
        allNodeIds.insert(node.identifier.text)
        allDeclSyntax.append(node)
    }
    
    override func visitPost(_ node: StructDeclSyntax) {
        allNodeIds.insert(node.identifier.text)
        allDeclSyntax.append(node)
    }
    
    override func visitPost(_ node: ExtensionDeclSyntax) {
        allDeclSyntax.append(node)
    }
}


class TypeUsageCollector: SyntaxVisitor {
    
    var declNode: DeclarationNode
    
    var allDeclNodes: Set<String>
    
    init(declNode: DeclarationNode, allDeclNodes: Set<String>) {
        self.declNode = declNode
        self.allDeclNodes = allDeclNodes
    }
    
    override func visitPost(_ node: SimpleTypeIdentifierSyntax) {
        let nodeId = node.name.withoutTrivia().description
        guard allDeclNodes.contains(nodeId) else {
            return
        }
        declNode.add(use: nodeId)
    }
    
    override func visitPost(_ node: IdentifierExprSyntax) {
        let nodeId = node.withoutTrivia().description
        guard allDeclNodes.contains(nodeId) else {
            return
        }
        declNode.add(use: nodeId)
    }
}
