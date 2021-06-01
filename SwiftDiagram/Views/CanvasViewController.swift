//
//  CanvasViewController.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/5/21.
//

import Cocoa
import SwiftSyntax
import SnapKit

class CanvasViewController: NSViewController {
    
    var contentView: NSView!
    var canvasView: CanvasView!
    
    private let canvasCoordinator: CanvasCoordinator = DefaultCanvasCoordinator()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        makeContentView()
        makeCanvasView()
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
    
    private func makeContentView() {
        contentView = NSView()
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
    
    private func makeCanvasView() {
        canvasView = CanvasView()
        canvasView.documentView = contentView
        view.addSubview(canvasView)
        canvasView.snp.makeConstraints{ $0.edges.equalTo(view) }
        contentView.snp.makeConstraints{
            $0.width.equalTo(3000)
            $0.height.equalTo(1000)
        }
    }
    
    private func coordinate(_ nodes: [DeclarationNode]) {
        canvasCoordinator.coordinate(nodes) { node, rect in
            self.display(node, in: rect)
        }
    }
    
    private func display(_ node: DeclarationNode, in frame: NSRect) {
        contentView.addSubview(SwiftDeclarationNode(frame: frame, node))
    }
}

