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
    var declarationNode: DeclarationNode
    
    
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
        self.declarationNode = NullNode()
        super.init(coder: coder)
    }
    
    func remove() {
        outgoingLines.forEach { $0.removeFromSuperlayer() }
        incomingLines.forEach { $0.removeFromSuperlayer() }
        removeFromSuperview()
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        zip(outgoingNodes, outgoingLines).forEach { node, line in
            line.path = makeArrowPath(from: node, to: self).cgPath
        }
        zip(incomingNodes, incomingLines).forEach { node, line in
            line.path = makeArrowPath(from: self, to: node).cgPath
        }
    }
    
    
    func makeArrowPath(from startNode: DeclarationNodeView,
                       to endNode: DeclarationNodeView) -> ArrowPath {
        
        var startEndAngle = atan((endNode.center.y - startNode.center.y) / (endNode.center.x - startNode.center.x)) + ((endNode.center.x - startNode.center.x) < 0 ? CGFloat.pi : 0)
        let degreeToRadian = CGFloat.pi / 180
        if startEndAngle < 0 {
            startEndAngle = 360 * degreeToRadian + startEndAngle
        }

        let edgePoint = endNode.findEdgePoint(angle: startEndAngle)
        let computedEdge = CGPoint(x: endNode.center.x+edgePoint.x, y: endNode.center.y+edgePoint.y)
        return ArrowPath(start: startNode.center, end: computedEdge)
    }
}
