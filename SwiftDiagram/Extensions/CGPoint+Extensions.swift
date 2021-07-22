//
//  CGPoint+Extensions.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 7/18/21.
//

import Foundation


public extension CGPoint {
    func distance(to secondPoint: Self) -> CGFloat {
        return sqrt(pow(secondPoint.x-self.x, 2)+pow(secondPoint.y-self.y,2))
    }
    
    static func angleBetweenThreePoints(center: CGPoint, firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        let firstAngle = atan2(firstPoint.y - center.y, firstPoint.x - center.x)
        let secondAngle = atan2(secondPoint.y - center.y, secondPoint.x - center.x)
        var angleDiff = firstAngle - secondAngle
        
        if angleDiff < 0 {
            angleDiff *= -1
        }
        
        return angleDiff
    }
    
    func angleBetweenPoints(firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        return CGPoint.angleBetweenThreePoints(center: self, firstPoint: firstPoint, secondPoint: secondPoint)
    }
}
