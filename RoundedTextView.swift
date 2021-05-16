//
//  RoundedTextView.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/5/21.
//

import AppKit

class RoundedTextView: DraggableView {
    
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
        layer?.backgroundColor = NSColor.lightGray.cgColor
        
        
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
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct RoundedTextView_Preview: PreviewProvider {
    static var previews: some View {
        NSViewPreview {
            let roundedTextView = RoundedTextView()
            roundedTextView.text = "AppDelegate"
            return roundedTextView
        }.previewLayout(.fixed(width: 400, height: 250))
        .padding(10)
    }
}
#endif
