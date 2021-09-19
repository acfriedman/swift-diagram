//
//  NSToolbar+Extensions.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 8/9/21.
//

import Foundation
import AppKit

extension NSToolbar.Identifier {
    static let mainWindowToolbarIdentifier = NSToolbar.Identifier("MainWindowToolbar")
}

extension NSToolbarItem.Identifier
{
    static let searchItem = NSToolbarItem.Identifier("ToolbarSearchItem")
    
    static let addButtonItem = NSToolbarItem.Identifier("ToolbarAddButtonItem")
}
