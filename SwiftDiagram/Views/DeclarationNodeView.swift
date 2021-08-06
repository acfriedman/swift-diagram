//
//  DeclarationNodeView.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/19/21.
//

import AppKit

protocol DeclarationNodeViewDelegate: AnyObject {
    func declarationNodeViewMouseDidDrag(_ nodeView: DeclarationNodeView)
}

class DeclarationNodeView: RoundedTextView {
    
    var outgoingLines: [CAShapeLayer] = []
    var incomingLines: [CAShapeLayer] = []
    var outgoingNodes: [DeclarationNodeView] = []
    var incomingNodes: [DeclarationNodeView] = []
    var declarationNode: DeclarationNode
    weak var delegate: DeclarationNodeViewDelegate?
    
    
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
    
    
    /// Removes the node view and its associated lines from the parent view
    func remove() {
        outgoingLines.forEach { $0.removeFromSuperlayer() }
        incomingLines.forEach { $0.removeFromSuperlayer() }
        removeFromSuperview()
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        delegate?.declarationNodeViewMouseDidDrag(self)
    }
}
