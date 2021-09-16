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
    
    var inheritance: [String] = [] {
        didSet {
            let inheritanceMenu = NSMenu(title: "Parents")
            inheritanceMenu.items = inheritance.map {
                let item = NSMenuItem(title: $0, action: #selector(selectMenuItem(_:)), keyEquivalent: "")
                item.target = self
                return item
            }
            inheritanceMenuItem.submenu = inheritanceMenu
            inheritanceMenuItem.isEnabled = inheritance.count > 0
        }
    }
    
    var usage: [String] = [] {
        didSet {
            let usageMenu = NSMenu(title: "Uses")
            usageMenu.items = usage.map {
                let item = NSMenuItem(title: $0, action: #selector(selectMenuItem(_:)), keyEquivalent: "")
                item.target = self
                return item
            }
            usageMenuItem.submenu = usageMenu
            usageMenuItem.isEnabled = usage.count > 0
        }
    }
    
    var children: [String] = [] {
        didSet {
            let childrenMenu = NSMenu(title: "Children")
            childrenMenu.items = children.map {
                let item = NSMenuItem(title: $0, action: #selector(selectMenuItem(_:)), keyEquivalent: "")
                item.target = self
                return item
            }
            childrenMenuItem.submenu = childrenMenu
            childrenMenuItem.isEnabled = children.count > 0
        }
    }
    
    var usedBy: [String] = [] {
        didSet {
            let usedByMenu = NSMenu(title: "Used By")
            usedByMenu.items = usedBy.map {
                let item = NSMenuItem(title: $0, action: #selector(selectMenuItem(_:)), keyEquivalent: "")
                item.target = self
                return item
            }
            usedByMenuItem.submenu = usedByMenu
            usedByMenuItem.isEnabled = usedBy.count > 0
        }
    }
    
    private var inheritanceMenuItem: NSMenuItem!
    
    private var usageMenuItem: NSMenuItem!
    
    private var childrenMenuItem: NSMenuItem!
    
    private var usedByMenuItem: NSMenuItem!
    
    override init(title: String) {
        super.init(title: title)
        initView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        inheritanceMenuItem = NSMenuItem(title: "Parents", action: nil, keyEquivalent: "")
        addItem(inheritanceMenuItem)
        
        childrenMenuItem = NSMenuItem(title: "Children", action: nil, keyEquivalent: "")
        addItem(childrenMenuItem)
                
        usageMenuItem = NSMenuItem(title: "Uses", action: nil, keyEquivalent: "")
        addItem(usageMenuItem)
        
        usedByMenuItem = NSMenuItem(title: "Used By", action: nil, keyEquivalent: "")
        addItem(usedByMenuItem)
    }
    
    @objc func selectMenuItem(_ menuItem: NSMenuItem) {
        nodeViewDelegate?.nodeViewMenu(self, didSelectItem: menuItem)
    }
}
