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
    var declarationNode: DeclarationNode?
    
    init(frame: NSRect, _ node: DeclarationNode) {
        
        self.declarationNode = node
        super.init(frame: frame)
        
        layer?.backgroundColor = node.displayColor.cgColor
        text = node.name
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func makeInheritanceLines(to nodes: [DeclarationNodeView]) -> [CAShapeLayer] {
        
        return nodes.compactMap { node in
            
            guard !outgoingNodes.contains(node) else { return nil }
            
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
    
    func makeUsageLines(to nodes: [DeclarationNodeView]) -> [CAShapeLayer] {
        
        return nodes.compactMap { node in
            
            guard !outgoingNodes.contains(node) else { return nil }
            
            let path = NSBezierPath()
            path.move(to: center)
            path.line(to: node.center)
            
            let line = SolidLine(path: path.cgPath)
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
