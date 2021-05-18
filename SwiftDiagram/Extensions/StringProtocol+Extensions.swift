//
//  StringProtocol+Extensions.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/18/21.
//

import Foundation

extension StringProtocol {
    var trimmed: String {
        let startIndex = firstIndex(where: { !$0.isWhitespace }) ?? self.startIndex
        let endIndex = lastIndex(where: { !$0.isWhitespace }) ?? self.endIndex
        return String(self[startIndex...endIndex])
    }
}
