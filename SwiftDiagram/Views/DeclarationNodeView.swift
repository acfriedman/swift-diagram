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
    func nodeViewDidEnterHover(_ nodeView: DeclarationNodeView)
    func nodeViewDidExitHover(_ nodeView: DeclarationNodeView)
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
        
        let trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.activeInKeyWindow, .mouseEnteredAndExited],
            owner: self,
            userInfo: nil
        )

        addTrackingArea(trackingArea)
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
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        delegate?.nodeViewDidEnterHover(self)
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        delegate?.nodeViewDidExitHover(self)
    }
    
    // MARK: NodeViewMenuDelegate
    
    func nodeViewMenu(_ menu: NodeViewMenu, didSelectItem menuItem: NSMenuItem) {
        delegate?.nodeView(self, didSelectRelation: menuItem.title)
    }
}

enum RelationshipType {
    case child
    case parent
    case uses
    case usedBy
}

class SketchNodeView: RoundedTextView {
        
    var didSelectAddRelationship: ((SketchNodeView, RelationshipType) -> Void)?
    
    init(constructType: SwiftConstruct) {
        
        super.init(frame: NSRect(x: 0, y: 0, width: 100.0, height: 80.0)) // default frame
        wantsLayer = true
        layer?.borderWidth = 3.0
        layer?.borderColor = constructType.color.cgColor
        layer?.backgroundColor = Color.lightGrayBackground.cgColor
        
        let menu = NSMenu(title: "Actions")
        let ediTitle = NSMenuItem(title: "Rename", action: #selector(editTitle(_:)), keyEquivalent: "")
        menu.addItem(ediTitle)
        menu.addItem(NSMenuItem.separator())
        
        let addRelationshipMenuItem = NSMenuItem(title: "Add Relationship", action: nil, keyEquivalent: "")
        let addRelationshipMenu = NSMenu(title: "Add Relationship")
        addRelationshipMenuItem.submenu = addRelationshipMenu
        addRelationshipMenu.addItem(NSMenuItem(title: "Uses",
                                               action: #selector(usesMenuItemTapped(_:)),
                                               keyEquivalent: ""))
        addRelationshipMenu.addItem(NSMenuItem(title: "Used By",
                                               action: #selector(usedByMenuItemTapped(_:)),
                                               keyEquivalent: ""))
        addRelationshipMenu.addItem(NSMenuItem(title: "Child",
                                               action: #selector(childMenuItemTapped(_:)),
                                               keyEquivalent: ""))
        addRelationshipMenu.addItem(NSMenuItem(title: "Parent",
                                               action: #selector(parentMenuItemTapped(_:)),
                                               keyEquivalent: ""))
        menu.addItem(addRelationshipMenuItem)
        
        self.menu = menu
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func editTitle(_ sender: Any) {
        guard let title = getTitle() else {
            return
        }
        
        text = title
    }
    
    func getTitle() -> String? {
        let msg = NSAlert()
        msg.alertStyle = .informational
        msg.addButton(withTitle: "OK")
        msg.addButton(withTitle: "Cancel")
        msg.messageText = "Title"

        let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        msg.accessoryView = txt
        let response: NSApplication.ModalResponse = msg.runModal()

        if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
            return txt.stringValue
        }
        
        return nil
    }
    
    // MARK: Private Functions
    
    @objc func usesMenuItemTapped(_ sender: Any) {
        didSelectAddRelationship?(self, .uses)
    }
    
    @objc func usedByMenuItemTapped(_ sender: Any) {
        didSelectAddRelationship?(self, .usedBy)
    }
    
    @objc func childMenuItemTapped(_ sender: Any) {
        didSelectAddRelationship?(self, .child)
    }
    
    @objc func parentMenuItemTapped(_ sender: Any) {
        didSelectAddRelationship?(self, .parent)
    }
}
