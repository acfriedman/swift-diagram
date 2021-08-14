//
//  NodeViewMenu.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 8/14/21.
//

import AppKit

class NodeViewMenu: NSMenu {
    
    
    var inheritance: [String] = [] {
        didSet {
            let inheritanceMenu = NSMenu(title: "Inheritance")
            inheritanceMenu.items = inheritance.map {
                NSMenuItem(title: $0, action: nil, keyEquivalent: "")
            }
            inheritanceMenuItem.submenu = inheritanceMenu
            inheritanceMenuItem.isEnabled = inheritance.count > 0
        }
    }
    
    var usage: [String] = [] {
        didSet {
            let usageMenu = NSMenu(title: "Usage")
            usageMenu.items = usage.map {
                NSMenuItem(title: $0, action: nil, keyEquivalent: "")
            }
            usageMenuItem.submenu = usageMenu
            usageMenuItem.isEnabled = usage.count > 0
        }
    }
    
    var children: [String] = [] {
        didSet {
            let childrenMenu = NSMenu(title: "Children")
            childrenMenu.items = children.map {
                NSMenuItem(title: $0, action: nil, keyEquivalent: "")
            }
            childrenMenuItem.submenu = childrenMenu
            childrenMenuItem.isEnabled = children.count > 0
        }
    }
    
    private var inheritanceMenuItem: NSMenuItem!
    
    private var usageMenuItem: NSMenuItem!
    
    private var childrenMenuItem: NSMenuItem!
    
    override init(title: String) {
        super.init(title: title)
        initView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        inheritanceMenuItem = NSMenuItem(title: "Inheritance", action: nil, keyEquivalent: "")
        addItem(inheritanceMenuItem)
        
        usageMenuItem = NSMenuItem(title: "Usage", action: nil, keyEquivalent: "")
        addItem(usageMenuItem)
        
        childrenMenuItem = NSMenuItem(title: "Children", action: nil, keyEquivalent: "")
        addItem(childrenMenuItem)
    }
}
