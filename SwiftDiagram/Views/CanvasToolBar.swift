//
//  CanvasToolBar.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 8/7/21.
//

import AppKit

class CanvasToolBar: NSToolbar {
    
    init() {
        super.init(identifier: NSToolbar.Identifier.mainWindowToolbarIdentifier)
        allowsUserCustomization = true
        autosavesConfiguration = true
        displayMode = .default
        centeredItemIdentifier = NSToolbarItem.Identifier.toolbarSearchItem
    }
}
