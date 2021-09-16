//
//  DeclarationNodeView.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/19/21.
//

import AppKit

protocol DeclarationNodeViewDelegate: AnyObject {
    func nodeViewMouseDidDrag(_ nodeView: DeclarationNodeView)
    func nodeView(_ nodeView: DeclarationNodeView, didSelectRelation nodeTitle: String)
}

class DeclarationNodeView: RoundedTextView, NodeViewMenuDelegate {
    
    var outgoingLines: [CAShapeLayer] = []
    var incomingLines: [CAShapeLayer] = []
    var outgoingNodes: [DeclarationNodeView] = []
    var incomingNodes: [DeclarationNodeView] = []
    var declarationNode: DeclarationNode
    
    weak var delegate: DeclarationNodeViewDelegate?
    
    weak var relationshipMenu: NodeViewMenu!
    
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
        
        let nodeViewMenu = NodeViewMenu()
        nodeViewMenu.inheritance = Array(declarationNode.inheritance)
        nodeViewMenu.usage = Array(declarationNode.usage)
        nodeViewMenu.children = Array(declarationNode.children)
        nodeViewMenu.usedBy = Array(declarationNode.usedBy)
        nodeViewMenu.nodeViewDelegate = self
        menu = nodeViewMenu
        relationshipMenu = nodeViewMenu
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
    
    func removeLines() {
        outgoingLines.forEach { $0.removeFromSuperlayer() }
        incomingLines.forEach { $0.removeFromSuperlayer() }
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        delegate?.nodeViewMouseDidDrag(self)
    }
    
    // MARK: NodeViewMenuDelegate
    
    func nodeViewMenu(_ menu: NodeViewMenu, didSelectItem menuItem: NSMenuItem) {
        delegate?.nodeView(self, didSelectRelation: menuItem.title)
    }
}
