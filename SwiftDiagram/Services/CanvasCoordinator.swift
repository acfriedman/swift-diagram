//
//  CanvasCoordinator.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/11/21.
//

import Foundation


struct CanvasCoordinator {
    
    func coordinate(_ nodes: [DeclarationNode], at point: CGPoint, display:  (DeclarationNode, NSRect) -> Void) {
        
        nodes.forEach { print($0.debugDescription + "\n") }
        
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
    
    func compute(nodes: [DeclarationNode]) {
        
        let nodeMap: [String: DeclarationNode] =
            nodes.reduce(into: [String: DeclarationNode](), { $0[$1.name] = $1  } )
        let nodeIndex: Set<String> =
            nodes.reduce(into: Set<String>(), { $0.insert($1.name)  })
        
        
        var nodeHash: [String: Set<String>] = [:]
        nodes.forEach { node in
            node.inheritance.forEach { nodeHash[$0, default: []].insert(node.name) }
        }
        
        let noInher = nodes.filter {
            Set($0.inheritance).subtracting(nodeIndex).count > 0 || $0.inheritance.count == 0
        }
        
        let startQueue = nodeHash.keys.compactMap { nodeMap[$0] }
        let queue: [DeclarationNode] = startQueue
        
        noInher.forEach { print("\($0)\n")}
    }
    
    
    // 1. The queue should start subclasses that either have no inheritance, OR, inherit from a Cocoa or NS Framework, i.e, some class that is not a new decleration of the the selected project.
    // 2. Each of these nodes should have an array of nodes that inherit from it.
    // 3. The arlgorithm will use a breadth first approach to plotting associated nodes.
}
