//
//  DashedLine.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 7/2/21.
//

import AppKit

protocol RelationshipLine { }
extension CAShapeLayer: RelationshipLine { }

class DashedLine: CAShapeLayer {
    
    convenience init(path: CGPath) {
        self.init()
        self.path = path
    }
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        name = "DashedLine"
        fillColor = .clear
        strokeColor = .black
        lineWidth = 2
        lineJoin = .miter
        lineDashPattern = [10, 10]
    }
}
