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
}
