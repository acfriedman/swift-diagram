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

        
    // MARK: Mouse Events
    
    var mouseDownClickPoint: CGPoint!
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    override func mouseDown(with event: NSEvent) {
        mouseDownClickPoint = convert(event.locationInWindow, from: nil)
    }
    
    override func mouseDragged(with event: NSEvent) {
                
        guard let newDragLocation = superview?.convert(event.locationInWindow, from: nil) else {
            return
        }
  
        snp.updateConstraints{
            $0.bottom.equalToSuperview().offset(-(newDragLocation.y - mouseDownClickPoint.y))
            $0.left.equalToSuperview().offset(newDragLocation.x - mouseDownClickPoint.x)
        }
    }
}
