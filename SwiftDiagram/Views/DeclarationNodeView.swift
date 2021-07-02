//
//  DeclarationNodeView.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/19/21.
//

import AppKit

class DeclarationNodeView: RoundedTextView {
    
    var outgoingLines: [CAShapeLayer] = []
    var incomingLines: [CAShapeLayer] = []
    var outgoingNodes: [DeclarationNodeView] = []
    var incomingNodes: [DeclarationNodeView] = []
    
    init(frame: NSRect, _ node: DeclarationNode) {
        super.init(frame: frame)
        
        layer?.backgroundColor = node.displayColor.cgColor
        text = node.name
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func makeLines(to nodes: [DeclarationNodeView]) -> [CAShapeLayer] {
        
        return nodes.compactMap { node in
            
            let path = NSBezierPath()
            path.move(to: center)
            path.line(to: node.center)
            
            let line = DashedLine(path: path.cgPath)
            node.incomingLines.append(line)
            outgoingLines.append(line)
            outgoingNodes.append(node)
            node.incomingNodes.append(self)
            return line
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        zip(outgoingNodes, outgoingLines).forEach { node, line in
            let path = NSBezierPath()
            path.move(to: center)
            path.line(to: node.center)
            line.path = path.cgPath
        }
        zip(incomingNodes, incomingLines).forEach { node, line in
            let path = NSBezierPath()
            path.move(to: node.center)
            path.line(to: center)
            line.path = path.cgPath
        }
    }
}
