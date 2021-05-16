//
//  SwiftUI+AppKit.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/15/21.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13, *)
public struct NSViewPreview<View: NSView>: NSViewRepresentable {
    public let view: View
 
    public init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    public func makeNSView(context: Context) -> View {
        return view
    }
    
    public func updateNSView(_ nsView: View, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif
