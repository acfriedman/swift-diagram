//
//  ViewController.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/5/21.
//

import Cocoa
import SwiftSyntax

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        FilePicker.presentModal(completion: { result in
            switch result {
            case .success(let url):
                do {
                    let nodes = try SwiftViewer.parse(url)
                    nodes.forEach { self.display($0) }
                    
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    // MARK: Private Methods
    
    private func display(_ node: SyntaxNode) {
        let roundedBox = makeRoundedBox(with: node.name,
                       frame: NSRect(x: 50, y: 50, width: 100, height: 80),
                       color: node.displayColor)
        view.addSubview(roundedBox)
    }

    private func makeRoundedBox(with name: String, frame: NSRect, color: NSColor) -> RoundedTextView {
        let roundedTextView = RoundedTextView(frame: frame)
        roundedTextView.layer?.backgroundColor = color.cgColor
        roundedTextView.text = name
        return roundedTextView
    }
}

