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
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    override func mouseDown(with event: NSEvent) {
        guard let clickPoint = superview?.convert(event.locationInWindow, from: nil) else {
            return
        }
        
        print("Click point: \(clickPoint)")
        print("origin y: \(frame.origin.y)")
        print("height: \(frame.height)")
    }
    
    override func mouseDragged(with event: NSEvent) {
                
        guard let newDragLocation = superview?.convert(event.locationInWindow, from: nil) else {
            return
        }
                
        snp.updateConstraints{
            $0.bottom.equalToSuperview().offset(-(newDragLocation.y - frame.height/2))
            $0.left.equalToSuperview().offset(newDragLocation.x - frame.width/2)
        }
    }
}
