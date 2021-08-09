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
            let canvasToolBar = CanvasToolBar()
            canvasToolBar.delegate = self
            
            unwrappedWindow.titleVisibility = .hidden
            unwrappedWindow.toolbar = canvasToolBar
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
            searchItem.searchField.action = #selector(doThing(_:))
            searchItem.toolTip = "Search"
            return searchItem
        }
        
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier.toolbarSearchItem
        ]
        
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
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
    
    @objc func doThing(_ sender: NSSearchField) {
        print(sender.stringValue)
    }
}
