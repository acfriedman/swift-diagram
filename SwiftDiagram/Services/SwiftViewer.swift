//
//  SwiftViewer.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 4/29/21.
//

import Foundation
import SwiftSyntax


struct SwiftViewer {
    func parse(_ url: URL) throws {
        let sourceFileSyntax = try SyntaxParser.parse(url)
        extractStructs(from: sourceFileSyntax)
        extractClasses(from: sourceFileSyntax)
        extractProtocols(from: sourceFileSyntax)
    }
    
    func extractStructs(from sourceFileSyntax: SourceFileSyntax) {
        let structVisitor = StructVisitor()
        structVisitor.walk(sourceFileSyntax)
        let structArray = structVisitor.structs
        print(structArray)
    }
    
    func extractClasses(from sourceFileSyntax: SourceFileSyntax) {
        let classVisitor = ClassVisitor()
        classVisitor.walk(sourceFileSyntax)
        let classesArray = classVisitor.classes
        print(classesArray)
    }
    
    func extractProtocols(from sourceFileSyntax: SourceFileSyntax) {
        let protocolVisitor = ProtocolVisitor()
        protocolVisitor.walk(sourceFileSyntax)
        let protocolsArray = protocolVisitor.protocols
        print(protocolsArray)
    }
}

extension SwiftViewer {
    enum Error: Swift.Error {
        case couldNotFindFile
    }
}
extension SwiftViewer.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .couldNotFindFile:
            return "Could not find file, or file is not of swift type"
        }
    }
}

class StructVisitor: SyntaxVisitor {
    
    var structs: [String] = []
    
    override func visitPost(_ node: TokenSyntax) {
        guard node.tokenKind == .structKeyword,
              let structTextName = node.nextToken?.text else {
            return
        }
        structs += [structTextName]
    }
}

class ClassVisitor: SyntaxVisitor {
    
    var classes: [String] = []
    
    override func visitPost(_ node: TokenSyntax) {
        guard node.tokenKind == .classKeyword,
              let classTextName = node.nextToken?.text else {
            return
        }
        classes += [classTextName]
    }
}

class ProtocolVisitor: SyntaxVisitor {
    
    var protocols: [String] = []
    
    override func visitPost(_ node: TokenSyntax) {
        guard node.tokenKind == .protocolKeyword,
              let protocolTextName = node.nextToken?.text else {
            return
        }
        protocols += [protocolTextName]
    }
}

