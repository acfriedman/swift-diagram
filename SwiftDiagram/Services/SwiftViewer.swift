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
    static func parse(_ url: URL) throws -> [SyntaxNode] {
        let sourceFileSyntax = try SyntaxParser.parse(url)
        let visitor = DiagramVisitor()
        visitor.walk(sourceFileSyntax)
        return visitor.extractedNodes
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

class DiagramVisitor: SyntaxVisitor {
    
    var extractedNodes: [SyntaxNode] = []
    
    override func visitPost(_ node: TokenSyntax) {
        guard let node = try? SyntaxNodeFactory.make(from: node) else {
            return
        }
        extractedNodes += [node]
    }
}
