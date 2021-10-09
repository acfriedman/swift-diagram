//
//  CanvasCoordinator.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/11/21.
//

import Foundation
import AppKit

class CanvasCoordinator {
    
    enum Error: Swift.Error {
        case noSuchNodeName
        case duplicatePlotAttempt
    }
    
    var nodes: [DeclarationNode] = [] {
        didSet {
            nodeIndex = nodes.reduce(into: [String: DeclarationNode](), { $0[$1.name] = $1 })
        }
    }
    
    private var nodeIndex: [String: DeclarationNode] = [:]
    
    private var relationshipMapper: RelationshipMapper!
    
    private var canvasView: CanvasView
    
    private var nodeViewIndex: [String: DeclarationNodeView] = [:]
    
    
    init(canvasView: CanvasView) {
        self.canvasView = canvasView
        self.relationshipMapper = RelationshipMapper(canvasView: canvasView)
    }
    
    func plotNode(_ name: String) throws {
        
        guard let node = nodeIndex[name] else {
            throw Error.noSuchNodeName
        }
        
        guard nodeViewIndex[name] == nil else {
            throw Error.duplicatePlotAttempt
        }
        
        let frame = CGRect(x: 0, y: 0, width: node.displayWidth, height: node.displayHeight)
        let nodeView = DeclarationNodeView(frame: frame, node)
        nodeView.delegate = self
        
        relationshipMapper.clearAllLines()
        coordinate(nodeView)
    }
    
    func coordinate(_ node: DeclarationNodeView) {
        coordinate([node])
    }
    
    func coordinate(_ nodes: [DeclarationNodeView]) {
        
        let area = computeArea(for: nodes)
        let maxX = area/2
        let maxY = area/2
        let viewCenter = canvasView.documentView!.center
        
        nodes.forEach { nodeView in
            let node = nodeView.declarationNode
            let plotPoint = NSRect(x: viewCenter.x + .random(in: -maxX/2...maxX/2),
                                   y: viewCenter.y + .random(in: -maxY/2...maxY/2),
                                   width: node.displayWidth,
                                   height: node.displayHeight)
            nodeView.frame = plotPoint
            canvasView.add(nodeView)
            nodeViewIndex[node.name] = nodeView
        }
        
        relationshipMapper.mapLines(Array(nodeViewIndex.values))
    }
    
    func plot(type: SwiftConstruct) {
        
        let viewCenter = canvasView.documentView!.center
        let sketchNodeView = SketchNodeView(constructType: type)
        sketchNodeView.didSelectAddRelationship = { [weak self] view, relationship in
            
            guard let self = self else {
                return
            }
            
            self.relationshipMapper.startEditing(relationship, for: view)
        }
        
        sketchNodeView.frame = CGRect(x: viewCenter.x,
                                      y: viewCenter.y,
                                      width: sketchNodeView.frame.width,
                                      height: sketchNodeView.frame.height)
        canvasView.add(sketchNodeView)
    }
    
    func remove(_ nodes: [DeclarationNodeView]) {
        nodes.forEach { node in
            nodeViewIndex.removeValue(forKey: node.declarationNode.name)
            node.remove()
        }
    }
    
    private func computeArea(for nodes: [DeclarationNodeView]) -> CGFloat {
        guard let node = nodes.first else { return 0.0 }
        let maxDimension = max(node.frame.width, node.frame.height)
        return maxDimension * CGFloat(nodes.count)
    }
}

extension CanvasCoordinator: DeclarationNodeViewDelegate {
    
    func nodeViewMouseDidDrag(_ nodeView: DeclarationNodeView) {
        relationshipMapper.updatePaths(for: nodeView)
    }
    
    func nodeView(_ nodeView: DeclarationNodeView, didSelectRelation nodeTitle: String) {
        do {
            try plotNode(nodeTitle)
        } catch {
            print("Failed to plot selected menu item with error: \(error)")
        }
    }
    
    func nodeViewDidEnterHover(_ nodeView: DeclarationNodeView) {
        if relationshipMapper.editingArrow != nil {
            nodeView.isHighlighted = true
        }
    }
    
    func nodeViewDidExitHover(_ nodeView: DeclarationNodeView) {
        if relationshipMapper.editingArrow != nil {
            nodeView.isHighlighted = false
        }
    }
}
