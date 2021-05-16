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
}
