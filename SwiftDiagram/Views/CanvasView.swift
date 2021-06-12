//
//  CanvasView.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/15/21.
//

import AppKit
import SnapKit

class CanvasView: NSScrollView {
    
    private var mouseDownLocation: NSPoint!
    private var lastScrollPoint: NSPoint = NSPoint(x: 0, y: 0)
    
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
        backgroundColor = NSColor.green
        clipView.snp.makeConstraints { $0.edges.equalTo(self) }
    }
    
    override func scrollWheel(with event: NSEvent) {
        let deltaY = event.scrollingDeltaY
        let magnification = magnification + deltaY/30
        let point = contentView.convert(event.locationInWindow, from: nil)
        setMagnification(magnification, centeredAt: point)
        if magnification < 1.0 {
            documentView?.snp.updateConstraints {
                $0.height.equalTo(documentVisibleRect.height)
                $0.width.equalTo(documentVisibleRect.width)
            }
        }
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    override func rightMouseDown(with event: NSEvent) {
        mouseDownLocation = event.locationInWindow
    }
        
    override func rightMouseUp(with event: NSEvent) {
        lastScrollPoint = NSPoint(x: contentView.documentVisibleRect.minX,
                                  y: contentView.documentVisibleRect.minY)
    }
    
    override func rightMouseDragged(with event: NSEvent) {
        let startPoint = event.locationInWindow
        var newPoint = NSPoint()
        newPoint.y = mouseDownLocation.y - startPoint.y + lastScrollPoint.y
        newPoint.x = mouseDownLocation.x - startPoint.x + lastScrollPoint.x
        contentView.scroll(newPoint)
    }
}
