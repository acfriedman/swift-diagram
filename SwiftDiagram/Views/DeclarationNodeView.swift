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
    
    
    var isHighlighted: Bool = false {
        didSet {
            if isHighlighted {
                layer?.borderWidth = 4.0
                layer?.borderColor = .init(red: 0.35, green: 0.99, blue: 0.06, alpha: 1.00)
            } else {
                layer?.borderWidth = 0.0
                layer?.borderColor = .clear
            }
        }
    }
    
    init(frame: NSRect, _ node: DeclarationNode) {
        
        self.declarationNode = node
        super.init(frame: frame)
        
        wantsLayer = true
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
    
    func remove() {
        outgoingLines.forEach { $0.removeFromSuperlayer() }
        incomingLines.forEach { $0.removeFromSuperlayer() }
        removeFromSuperview()
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
