//
//  NSView+Extensions.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/19/21.
//

import Foundation
import AppKit

extension NSView {
    var center: CGPoint {
        return CGPoint(x: (frame.origin.x + (frame.size.width / 2)),
                       y: (frame.origin.y + (frame.size.height / 2)))
    }
}
