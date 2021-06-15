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
    
    private let canvasCoordinator = CanvasCoordinator()
        
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
                    self.drawInheritanceLines()
                    
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    
        let scrollPoint = NSPoint(x: contentView.center.x - (canvasView.frame.width/2),
                                  y: contentView.center.y - (canvasView.frame.height/2))
        canvasView.contentView.scroll(to: scrollPoint)
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
            $0.width.equalTo(5000)
            $0.height.equalTo(5000)
        }
    }
    
    private var nodeIndex: [String: DeclarationNodeView] = [:]
    private var nodeMap: [String: Set<DeclarationNodeView>] = [:]
    
    private func coordinate(_ nodes: [DeclarationNode]) {
        canvasCoordinator.coordinate(nodes, at: contentView.center) { node, rect in
            let displayNode = display(node, in: rect)
            nodeIndex[node.name] = displayNode
            node.inheritance.forEach { nodeMap[$0, default: []].insert(displayNode) }
        }
    }
    
    private func drawInheritanceLines() {
        for (key, inheritedDecls) in nodeMap {
            nodeIndex[key]?
                .makeLines(to: Array(inheritedDecls))
                .forEach { contentView.layer?.addSublayer($0) }
        }
    }
    
    private func display(_ node: DeclarationNode, in frame: NSRect) -> DeclarationNodeView {
        let nodeView = DeclarationNodeView(frame: frame, node)
        contentView.addSubview(nodeView)
        return nodeView
    }
}

