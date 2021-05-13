//
//  ViewController.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/5/21.
//

import Cocoa
import SwiftSyntax

class ViewController: NSViewController {
    
    private let canvasCoordinator: CanvasCoordinator = DefaultCanvasCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = .white
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        FilePicker.presentModal(completion: { result in
            switch result {
            case .success(let urls):
                do {
                    let nodes = try SwiftViewer.parse(urls)
                    self.coordinate(nodes)
                    
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    // MARK: Private Methods
    
    private func coordinate(_ nodes: [SyntaxNode]) {
        canvasCoordinator.coordinate(nodes) { node, rect in
            self.display(node, in: rect)
        }
    }
    
    private func display(_ node: SyntaxNode, in frame: NSRect) {
        let roundedBox = makeRoundedBox(with: node.name,
                       frame: frame,
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

