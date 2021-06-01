//
//  SwiftDeclarationNode.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/19/21.
//

import AppKit

class SwiftDeclarationNode: RoundedTextView {
    
    var outgoingLines: [CAShapeLayer] = []
    var incomingLines: [CAShapeLayer] = []
    var outgoingNodes: [SwiftDeclarationNode] = []
    var incomingNodes: [SwiftDeclarationNode] = []
    
    init(frame: NSRect, _ node: DeclarationNode) {
        super.init(frame: frame)
        
        layer?.backgroundColor = node.displayColor.cgColor
        text = node.name
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func makeLines(to nodes: [SwiftDeclarationNode]) -> [CAShapeLayer] {
        
        let path = NSBezierPath()
        path.move(to: center)
        nodes.forEach { path.line(to: $0.center) }
        
        return nodes.compactMap { node in
            let line = CAShapeLayer()
            line.path = path.cgPath
            line.lineWidth = 3
            line.strokeColor = .black
            node.incomingLines.append(line)
            outgoingLines.append(line)
            outgoingNodes.append(node)
            node.incomingNodes.append(self)
            return line
        }
    }
}
