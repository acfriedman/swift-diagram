//
//  CanvasCoordinator.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/11/21.
//

import Foundation
import AppKit

struct CanvasCoordinator {
    
    private var contentView: NSView
    
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
        }
    }
    
    private func computeArea(for nodes: [DeclarationNodeView]) -> CGFloat {
        guard let node = nodes.first else { return 0.0 }
        let maxDimension = max(node.frame.width, node.frame.height)
        return maxDimension * CGFloat(nodes.count)
    }
}
