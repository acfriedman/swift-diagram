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
    
    static func parse(_ urls: [URL]) throws -> [SyntaxNode] {
        return urls.compactMap { try? parse($0) }.flatMap { $0 }
    }
    
    static func parse(_ url: URL) throws -> [SyntaxNode] {
        
        guard acceptableFileTypes.contains(url.pathExtension) else {
            throw Error.unacceptableFileTypeExtension
        }
        
        let sourceFileSyntax = try SyntaxParser.parse(url)
        let visitor = DiagramVisitor()
        visitor.walk(sourceFileSyntax)
        return visitor.extractedNodes
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

class DiagramVisitor: SyntaxVisitor {
    
    var extractedNodes: [SyntaxNode] = []
    
    override func visitPost(_ node: TokenSyntax) {
        guard let node = try? SyntaxNodeFactory.make(from: node) else {
            return
        }
        extractedNodes += [node]
    }
}
