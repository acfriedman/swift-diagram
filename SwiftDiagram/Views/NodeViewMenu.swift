//
//  NodeViewMenu.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 8/14/21.
//

import AppKit

protocol NodeViewMenuDelegate: AnyObject {
    func nodeViewMenu(_ menu: NodeViewMenu, didSelectItem menuItem: NSMenuItem)
}

class NodeViewMenu: NSMenu {
    
    weak var nodeViewDelegate: NodeViewMenuDelegate?
            
    var menusForNode: ((_ node: DeclarationNode) -> [NSMenu])? {
        didSet {
            
            guard let menus = menusForNode?(node) else {
                print("WARN: No data provided for menu at index")
                return
            }
            
            menus.forEach { menu in
                menu.items.forEach {
                    $0.action = #selector(selectMenuItem(_:))
                    $0.target = self
                }
                let menuItem = NSMenuItem(title: menu.title, action: nil, keyEquivalent: "")
                menuItem.submenu = menu
                addItem(menuItem)
            }
        }
    }
    
    private let node: DeclarationNode
    
    init(node: DeclarationNode) {
        self.node = node
        super.init(title: "")
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }
    
    @objc func selectMenuItem(_ menuItem: NSMenuItem) {
        nodeViewDelegate?.nodeViewMenu(self, didSelectItem: menuItem)
    }
}
