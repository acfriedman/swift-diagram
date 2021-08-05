//
//  RelationshipMapper.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 8/5/21.
//

import Foundation
import AppKit

struct RelationshipMapper {
    
    private let contentView: NSView!
    
    private var nodeIndex: [String: DeclarationNodeView] = [:]
    
    private var inheritanceMap: [String: Set<DeclarationNodeView>] = [:]
    
    private var usageMap: [String: Set<DeclarationNodeView>] = [:]
    
    init(contentView: NSView) {
        self.contentView = contentView
    }
    
    mutating func map(_ nodes: [DeclarationNodeView]) {
        
        nodes.forEach { nodeView in
            let node = nodeView.declarationNode
            nodeIndex[node.name] = nodeView
            node.inheritance.forEach { inheritanceMap[$0, default: []].insert(nodeView) }
            node.usage.forEach { usageMap[$0, default: []].insert(nodeView) }
        }
        
        
        drawInheritanceLines()
        drawUsageLines()
    }
    
    private func drawInheritanceLines() {
        
        // for each key in the inheritanceMap
        // relationshipMapper.draw(to: decl)
        
        for (key, inheritedDecls) in inheritanceMap {
            nodeIndex[key]?
                .makeInheritanceLines(to: Array(inheritedDecls))
                .forEach { contentView.layer?.addSublayer($0) }
        }
    }
    
    private func drawUsageLines() {
        for (key, usageDecls) in usageMap {
            nodeIndex[key]?
                .makeUsageLines(to: Array(usageDecls))
                .forEach { contentView.layer?.addSublayer($0) }
        }
    }
}
