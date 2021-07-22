//
//  NSView+Extensions.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/19/21.
//

import Foundation
import AppKit

extension NSView {
    
    var center: CGPoint {
        return CGPoint(x: (frame.origin.x + (frame.size.width / 2)),
                       y: (frame.origin.y + (frame.size.height / 2)))
    }
    
    public func findEdgePoint(angle: CGFloat) -> CGPoint {

        let intersection: CGPoint

        let xRad = frame.width / 2
        let yRad = frame.height / 2
        
        let degree = angle * 180 / .pi
        print("degree: \(degree)")

        let tangent = tan(angle)
        let y = xRad * CGFloat(tangent)

        if abs(y) <= yRad {

            if angle < CGFloat.pi / 2 || angle > 3 * CGFloat.pi / 2 {
                intersection = CGPoint(x: -xRad, y: -y)
            } else {
                intersection = CGPoint(x: xRad, y: y)
            }
        } else {

            let x = yRad / CGFloat(tangent)

            if degree < 0 {
                intersection = CGPoint(x: x, y: yRad)
            }
            else if angle < CGFloat.pi {
                intersection = CGPoint(x: -x, y: -yRad)
            } else {
                intersection = CGPoint(x: x, y: yRad)
            }
        }

        return intersection
    }
}
