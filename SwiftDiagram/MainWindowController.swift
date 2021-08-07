//
//  MainWindowController.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 8/7/21.
//

import AppKit

class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        configureToolbar()
    }
    
    private func configureToolbar()
    {
        if  let unwrappedWindow = window {
            
            let newToolbar = NSToolbar(identifier: NSToolbar.Identifier.mainWindowToolbarIdentifier)
            newToolbar.delegate = self
            newToolbar.allowsUserCustomization = true
            newToolbar.autosavesConfiguration = true
            newToolbar.displayMode = .default
            
            // Example on center-pinning a toolbar item
            newToolbar.centeredItemIdentifier = NSToolbarItem.Identifier.toolbarPickerItem
            
            // Hiding the title visibility in order to gain more toolbar space.
            // Set this property to .visible or delete this line to get it back.
            unwrappedWindow.titleVisibility = .hidden
            unwrappedWindow.toolbar = newToolbar
            unwrappedWindow.toolbar?.validateVisibleItems()
        }
    }
}

extension MainWindowController: NSToolbarDelegate {
    
}

extension NSToolbar.Identifier {
    static let mainWindowToolbarIdentifier = NSToolbar.Identifier("MainWindowToolbar")
}

extension NSToolbarItem.Identifier
{
    //  Standard examples of `NSToolbarItem`
    static let toolbarItemToggleTitlebarAccessory = NSToolbarItem.Identifier("ToolbarToggleTitlebarAccessoryItem")
    
    //  `visibilityPriority` is set to `.low` for these items to demonstrate how
    //  to make some items disappear before others when space gets a bit tight.
    static let toolbarItemMoreInfo = NSToolbarItem.Identifier("ToolbarMoreInfoItem")
    static let toolbarItemUserAccounts = NSToolbarItem.Identifier("ToolbarUserAccountsItem")
    
    /// Example of `NSMenuToolbarItem`
    static let toolbarMoreActions = NSToolbarItem.Identifier("ToolbarMoreActionsItem")
    
    /// Example of `NSSharingServicePickerToolbarItem`
    static let toolbarShareButtonItem = NSToolbarItem.Identifier(rawValue: "ToolbarShareButtonItem")
    
    /// Example of `NSToolbarItemGroup`
    static let toolbarPickerItem = NSToolbarItem.Identifier("ToolbarPickerItemGroup")
    
    /// Example of `NSSearchToolbarItem`
    static let toolbarSearchItem = NSToolbarItem.Identifier("ToolbarSearchItem")
}
