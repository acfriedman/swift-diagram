//
//  SolidLine.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 7/2/21.
//

import AppKit

class SolidLine: CAShapeLayer {

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
        name = "SolidLine"
        strokeColor = .black
        lineWidth = 2
    }
    
}
