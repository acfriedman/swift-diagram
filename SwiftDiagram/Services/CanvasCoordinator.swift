//
//  CanvasCoordinator.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/11/21.
//

import Foundation


struct CanvasCoordinator {
    
    func coordinate(_ nodes: [DeclarationNode], at point: CGPoint, display:  (DeclarationNode, NSRect) -> Void) {
        
        let leadingInset: CGFloat = 8.0
        let yPoint: CGFloat = point.y
        var xPoint: CGFloat = point.x
        var placementRect: NSRect!
        
        nodes.forEach { node in
            xPoint += node.displayWidth + leadingInset
            placementRect = NSRect(x: xPoint,
                                   y: yPoint,
                                   width: node.displayWidth,
                                   height: node.displayHeight)
            display(node, placementRect)
        }
    }
}
