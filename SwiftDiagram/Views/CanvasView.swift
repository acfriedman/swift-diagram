//
//  CanvasView.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/15/21.
//

import AppKit
import SnapKit

class CanvasView: NSScrollView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        verticalScrollElasticity = .allowed
        horizontalScrollElasticity = .allowed
        hasHorizontalScroller = true
        hasVerticalScroller = true
        
        
        let clipView = NSClipView()
        contentView = clipView
        clipView.snp.makeConstraints { $0.edges.equalTo(self) }
    }
    
    var mouseDownLocation: NSPoint!
    var lastScrollPoint: NSPoint = NSPoint(x: 0, y: 0)
    
    override func mouseDown(with event: NSEvent) {
        mouseDownLocation = event.locationInWindow
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        let dragPoint = event.locationInWindow
        
        print("dragPoint: \(dragPoint)")
        print("mouseDownLocation: \(mouseDownLocation)")
        
        
        lastScrollPoint.y = mouseDownLocation.y - dragPoint.y
        lastScrollPoint.x = mouseDownLocation.x - dragPoint.x
                
        print("lastScrollPoint: \(lastScrollPoint)")
        print("\n\n")
        contentView.scroll(lastScrollPoint)
    }
}
