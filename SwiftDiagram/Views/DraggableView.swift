//
//  DraggableView.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/12/21.
//

import AppKit
import SnapKit

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
        
        print("New Drag Location: \(newDragLocation)")
        print("Location in Window: \(event.locationInWindow)")
        
        var thisOrigin = frame.origin
        thisOrigin.x += -lastDragLocation.x + newDragLocation.x
        thisOrigin.y += -lastDragLocation.y + newDragLocation.y
        
        snp.updateConstraints{
            $0.bottom.equalToSuperview().offset(-newDragLocation.y)
            $0.left.equalToSuperview().offset(newDragLocation.x)
        }
        
    }
}
