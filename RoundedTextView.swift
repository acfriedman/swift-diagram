//
//  RoundedTextView.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/5/21.
//

import AppKit

class RoundedTextView: NSView {
    
    var text: String {
        get { return textField.stringValue }
        set { textField.stringValue = newValue }
    }
    
    private var textField: NSTextField!
    
    private var lastDragLocation: NSPoint?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        
        wantsLayer = true
        layer?.masksToBounds = true
        layer?.cornerRadius = 10.0
        layer?.backgroundColor = NSColor.red.cgColor
        
        
        textField = NSTextField(frame: frame)
        textField.isEditable = false
        textField.isSelectable = false
        textField.textColor = .black
        textField.wantsLayer = true
        textField.alignment = .center
        textField.maximumNumberOfLines = 0
        textField.sizeToFit()
        addSubview(textField)
    }
    
    private func setupConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: 8),
        ])
    }
    
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
