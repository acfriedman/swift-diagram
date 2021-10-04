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

class SketchNodeView: RoundedTextView {
    
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
        print("Did tap uses menu item")
    }
    
    @objc func usedByMenuItemTapped(_ sender: Any) {
        print("Did tap used by menu item")
    }
    
    @objc func childMenuItemTapped(_ sender: Any) {
        print("Did tap child menu item")
    }
    
    @objc func parentMenuItemTapped(_ sender: Any) {
        print("Did tap parent menu item")
    }
}
