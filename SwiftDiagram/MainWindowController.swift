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
            newToolbar.centeredItemIdentifier = NSToolbarItem.Identifier.toolbarSearchItem
            
            unwrappedWindow.titleVisibility = .hidden
            unwrappedWindow.toolbar = newToolbar
            unwrappedWindow.toolbar?.validateVisibleItems()
        }
    }
}

extension MainWindowController: NSToolbarDelegate {
    
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        if  itemIdentifier == NSToolbarItem.Identifier.toolbarSearchItem {
            let searchItem = NSSearchToolbarItem(itemIdentifier: itemIdentifier)
            searchItem.resignsFirstResponderWithCancel = true
            searchItem.searchField.delegate = self
            searchItem.toolTip = "Search"
            return searchItem
        }
        
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier.toolbarItemToggleTitlebarAccessory,
            NSToolbarItem.Identifier.toolbarItemUserAccounts,
            NSToolbarItem.Identifier.toolbarItemMoreInfo,
            NSToolbarItem.Identifier.flexibleSpace,
            NSToolbarItem.Identifier.toolbarPickerItem,
            NSToolbarItem.Identifier.flexibleSpace,
            NSToolbarItem.Identifier.toolbarMoreActions,
            NSToolbarItem.Identifier.toolbarShareButtonItem,
            NSToolbarItem.Identifier.toolbarSearchItem
        ]
        
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier.toolbarItemToggleTitlebarAccessory,
            NSToolbarItem.Identifier.toolbarMoreActions,
            NSToolbarItem.Identifier.toolbarItemUserAccounts,
            NSToolbarItem.Identifier.toolbarItemMoreInfo,
            NSToolbarItem.Identifier.toolbarPickerItem,
            NSToolbarItem.Identifier.toolbarShareButtonItem,
            NSToolbarItem.Identifier.toolbarSearchItem,
            NSToolbarItem.Identifier.space,
            NSToolbarItem.Identifier.flexibleSpace]
    }
    
    func toolbarWillAddItem(_ notification: Notification)
    {
        // print("~ ~ toolbarWillAddItem: \(notification.userInfo!)")
    }
    
    func toolbarDidRemoveItem(_ notification: Notification)
    {
        // print("~ ~ toolbarDidRemoveItem: \(notification.userInfo!)")
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier]
    {
        // Return the identifiers you'd like to show as "selected" when clicked.
        // Similar to how they look in typical Preferences windows.
        return []
    }
    
}

extension MainWindowController: NSSearchFieldDelegate {
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        print("Search field did start receiving input")
    }
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        print("Search field did end receiving input")
        sender.resignFirstResponder()
    }
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
