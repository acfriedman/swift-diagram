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
                    self.drawLines()
                    
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
    
    private var nodeIndex: [String: DeclarationNodeView] = [:]
    private var nodeMap: [String: Set<DeclarationNodeView>] = [:]
    
    private func coordinate(_ nodes: [DeclarationNode]) {
        canvasCoordinator.coordinate(nodes) { node, rect in
            let displayNode = display(node, in: rect)
            nodeIndex[node.name] = displayNode
            node.inheritance.forEach { nodeMap[$0, default: []].insert(displayNode) }
        }
    }
    
    private func drawLines() {
        for map in nodeMap {
            nodeIndex[map.key]?
                .makeLines(to: Array(map.value))
                .forEach { contentView.layer?.addSublayer($0) }
            
        }
    }
    
    private func display(_ node: DeclarationNode, in frame: NSRect) -> DeclarationNodeView {
        let nodeView = DeclarationNodeView(frame: frame, node)
        contentView.addSubview(nodeView)
        return nodeView
    }
}

