//
//  CanvasView.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/15/21.
//

import AppKit
import SnapKit

class CanvasView: NSScrollView {
    
    var nodeViews: [DeclarationNodeView] = []
    var sketchViews: [SketchNodeView] = []
    var selectedNodes: [DeclarationNodeView] = []
    
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
    
    func add(_ nodeView: DeclarationNodeView) {
        nodeViews += [nodeView]
        documentView?.addSubview(nodeView)
    }
    
    func add(_ nodeView: SketchNodeView) {
        sketchViews += [nodeView]
        documentView?.addSubview(nodeView)
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
    
    var leftMouseDownPoint: NSPoint!
    var drawingShape: CAShapeLayer?
    
    override func mouseDown(with event: NSEvent) {
        
        leftMouseDownPoint = convert(event.locationInWindow, from: nil)
        
        let drawingShape = CAShapeLayer()
        drawingShape.lineWidth = 1.0
        drawingShape.fillColor = NSColor.clear.cgColor
        drawingShape.strokeColor = NSColor.black.cgColor
        drawingShape.lineDashPattern = [10,5]
        layer?.addSublayer(drawingShape)

        var dashAnimation = CABasicAnimation()
        dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        dashAnimation.duration = 0.75
        dashAnimation.fromValue = 0.0
        dashAnimation.toValue = 15.0
        dashAnimation.repeatCount = .infinity
        drawingShape.add(dashAnimation, forKey: "linePhase")
        self.drawingShape = drawingShape
    }
    
    override func mouseUp(with event: NSEvent) {
        
        guard let drawingShape = drawingShape else {
            return
        }
        
        var highlightedNodes: [DeclarationNodeView] = []
        for nodeView in nodeViews {
            if let path = drawingShape.path,
               convert(path.boundingBox, to: contentView).contains(nodeView.frame) {
                highlightedNodes.append(nodeView)
                nodeView.isHighlighted = true
            } else {
                nodeView.isHighlighted = false
            }
        }
        
        selectedNodes = highlightedNodes
        
        self.drawingShape?.removeFromSuperlayer()
        self.drawingShape = nil
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        let point : NSPoint = convert(event.locationInWindow, from: nil)
        let path = CGMutablePath()
        path.move(to: leftMouseDownPoint)
        path.addLine(to: NSPoint(x: leftMouseDownPoint.x, y: point.y))
        path.addLine(to: point)
        path.addLine(to: NSPoint(x:point.x, y: leftMouseDownPoint.y))
        path.closeSubpath()
        drawingShape?.path = path
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
