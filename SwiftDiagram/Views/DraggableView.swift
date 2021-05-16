//
//  DraggableView.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/12/21.
//

import AppKit

/// A view that can be relocated by clicking and dragging it within its superview
class DraggableView: NSView {

    // MARK: Private Variables
    
    private var lastDragLocation: NSPoint?
    
    // MARK: Mouse Events
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    override func mouseDown(with event: NSEvent) {
        lastDragLocation = superview?.convert(event.locationInWindow, from: nil)
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        guard let newDragLocation = superview?.convert(event.locationInWindow, from: nil),
              let lastDragLocation = lastDragLocation else {
            return
        }
        var thisOrigin = frame.origin
        thisOrigin.x += -lastDragLocation.x + newDragLocation.x
        thisOrigin.y += -lastDragLocation.y + newDragLocation.y
        setFrameOrigin(thisOrigin)
        self.lastDragLocation = newDragLocation
    }
}
