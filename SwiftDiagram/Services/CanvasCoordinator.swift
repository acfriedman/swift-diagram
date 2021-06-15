//
//  CanvasCoordinator.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/11/21.
//

import Foundation


struct CanvasCoordinator {
    
    func coordinate(_ nodes: [DeclarationNode], at point: CGPoint, display:  (DeclarationNode, NSRect) -> Void) {
        
        let area = computeArea(for: nodes)
        let maxX = area/2
        let maxY = area/2
                
        nodes.forEach { node in
            display(node, NSRect(x: point.x + CGFloat.random(in: -maxX/2...maxX/2),
                                 y: point.y + CGFloat.random(in: -maxY/2...maxY/2),
                                 width: node.displayWidth,
                                 height: node.displayHeight))
        }
    }
    
    private func computeArea(for nodes: [DeclarationNode]) -> CGFloat {
        guard let node = nodes.first else { return 0.0 }
        let maxDimension = max(node.displayWidth, node.displayHeight)
        return maxDimension * CGFloat(nodes.count)
    }
}
