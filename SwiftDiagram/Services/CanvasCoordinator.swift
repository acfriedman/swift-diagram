//
//  CanvasCoordinator.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/11/21.
//

import Foundation
import AppKit



protocol NodeViewCoordinator {
    
    init(contentView: NSView)
    mutating func coordinate(_ nodes: [DeclarationNodeView])
}

struct CanvasCoordinator: NodeViewCoordinator {
    
    private var contentView: NSView
    
    private var nodeIndex: [String: DeclarationNodeView] = [:]
    
    private var inheritanceMap: [String: Set<DeclarationNodeView>] = [:]
    
    private var usageMap: [String: Set<DeclarationNodeView>] = [:]
    
    init(contentView: NSView) {
        self.contentView = contentView
    }
    
    mutating func coordinate(_ nodes: [DeclarationNodeView]) {
        
        let area = computeArea(for: nodes)
        let maxX = area/2
        let maxY = area/2
        let viewCenter = contentView.center
        
        nodes.forEach { nodeView in
            let node = nodeView.declarationNode
            let plotPoint = NSRect(x: viewCenter.x + CGFloat.random(in: -maxX/2...maxX/2),
                                   y: viewCenter.y + CGFloat.random(in: -maxY/2...maxY/2),
                                   width: node.displayWidth,
                                   height: node.displayHeight)
            nodeView.frame = plotPoint
            contentView.addSubview(nodeView)
            
            nodeIndex[node.name] = nodeView
            node.inheritance.forEach { inheritanceMap[$0, default: []].insert(nodeView) }
            node.usage.forEach { usageMap[$0, default: []].insert(nodeView) }
        }
        
        drawInheritanceLines()
        drawUsageLines()
    }
    
    private func computeArea(for nodes: [DeclarationNodeView]) -> CGFloat {
        guard let node = nodes.first else { return 0.0 }
        let maxDimension = max(node.frame.width, node.frame.height)
        return maxDimension * CGFloat(nodes.count)
    }
    
    private func drawInheritanceLines() {
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
