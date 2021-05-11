//
//  CanvasCoordinator.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/11/21.
//

import Foundation

protocol CanvasCoordinator {
    func coordinate(_ nodes: [SyntaxNode], display: (SyntaxNode, NSRect) -> Void)
}

struct DefaultCanvasCoordinator: CanvasCoordinator {
    
    func coordinate(_ nodes: [SyntaxNode], display:  (SyntaxNode, NSRect) -> Void) {
        
        let leadingInset: CGFloat = 8.0
        let yPoint: CGFloat = 20.0
        var xPoint: CGFloat = leadingInset
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
