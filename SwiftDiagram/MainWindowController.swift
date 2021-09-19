//
//  MainWindowController.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 8/7/21.
//

import AppKit

protocol MainWindowControllerDelegate: AnyObject {
    func mainWindowController(_ controller: MainWindowController, didSearchFor text: String)
}

class MainWindowController: NSWindowController, NSToolbarItemValidation {
    
    weak var delegate: MainWindowControllerDelegate?
    
    /// Items for the `NSMenuToolbarItem`
    private var actionsMenu: NSMenu = {
        var menu = NSMenu(title: "")
        let menuItem1 = NSMenuItem(title: "Add", action: nil, keyEquivalent: "")
        menu.items = [menuItem1]
        return menu
    }()
    
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
    
    @objc func addButtonPressed(_ sender: Any) {
        print("hello world")
    }
    
    // MARK: NSToolbarItemValidation
    
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        return true
    }
}

extension MainWindowController: NSToolbarDelegate {
    
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        if  itemIdentifier == NSToolbarItem.Identifier.searchItem {
            let searchItem = NSSearchToolbarItem(itemIdentifier: itemIdentifier)
            searchItem.resignsFirstResponderWithCancel = true
            searchItem.searchField.delegate = self
            searchItem.toolTip = "Search"
            return searchItem
        }
        
        if  itemIdentifier == NSToolbarItem.Identifier.addButtonItem {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(addButtonPressed(_:))
            toolbarItem.title = "Add"
            toolbarItem.label = "Add"
            toolbarItem.paletteLabel = "Add"
            toolbarItem.toolTip = "Add blueprint object"
            toolbarItem.visibilityPriority = .high
            toolbarItem.isBordered = true
            return toolbarItem
        }
        
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier.flexibleSpace,
            NSToolbarItem.Identifier.addButtonItem,
            NSToolbarItem.Identifier.flexibleSpace,
            NSToolbarItem.Identifier.searchItem,
        ]
        
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier.searchItem,
            NSToolbarItem.Identifier.addButtonItem,
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
        //
    }
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        sender.resignFirstResponder()
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline) {
            delegate?.mainWindowController(self, didSearchFor: textView.string)
            textView.string = ""
            window?.makeFirstResponder(nil)
            return true
        }
        return false
    }
}
