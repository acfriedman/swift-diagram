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
        textField.layer?.backgroundColor = NSColor.green.cgColor
        textField.sizeToFit()
        addSubview(textField)
    }
    
    private func setupConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: 8),
        ])
    }
}
