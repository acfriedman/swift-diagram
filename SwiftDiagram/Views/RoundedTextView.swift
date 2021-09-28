//
//  RoundedTextView.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/5/21.
//

import AppKit
import SnapKit

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
    
    // MARK: - Private Functions
    
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
        textField.backgroundColor = .clear
        textField.drawsBackground = false
        textField.isBordered = false
        textField.sizeToFit()
        addSubview(textField)
    }
    
    private func setupConstraints() {
        textField.snp.makeConstraints {
            $0.leading.trailing.equalTo(self).inset(8)
            $0.centerY.equalTo(self)
        }
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


class AutoSizingTextField: NSTextField {
    
    override var intrinsicContentSize: NSSize {
        // Guard the cell exists and wraps
        guard let cell = self.cell, cell.wraps else { return super.intrinsicContentSize }

        // Use intrinsic width to jive with auto-layout
        let width = super.intrinsicContentSize.width

        // Calculate height
        let height = cell.cellSize(forBounds: self.frame).height

        return NSMakeSize(width, height);
    }

    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        super.invalidateIntrinsicContentSize()
    }
}
