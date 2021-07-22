//
//  Arrow.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 7/18/21.
//

import AppKit

class ArrowPath: NSBezierPath {

    init(start: CGPoint,
         end: CGPoint,
         pointerLineLength: CGFloat = 10.0,
         angle: CGFloat = CGFloat(Double.pi/8)) {
        
        super.init()
        
        move(to: start)
        line(to: end)
        
        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + angle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + angle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - angle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - angle))

        move(to: end)
        line(to: arrowLine1)
        move(to: end)
        line(to: arrowLine2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
