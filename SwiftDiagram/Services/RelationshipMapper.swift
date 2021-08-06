//
//  RelationshipMapper.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 8/5/21.
//

import Foundation
import AppKit

class RelationshipMapper: DeclarationNodeViewDelegate {
    
    private let contentView: NSView!
    
    private var nodeIndex: [String: DeclarationNodeView] = [:]
    
    private var inheritanceMap: [String: Set<DeclarationNodeView>] = [:]
    
    private var usageMap: [String: Set<DeclarationNodeView>] = [:]
    
    init(contentView: NSView) {
        self.contentView = contentView
    }
    
    func map(_ nodes: [DeclarationNodeView]) {
        
        nodes.forEach { nodeView in
            let node = nodeView.declarationNode
            nodeIndex[node.name] = nodeView
            node.inheritance.forEach { inheritanceMap[$0, default: []].insert(nodeView) }
            node.usage.forEach { usageMap[$0, default: []].insert(nodeView) }
            nodeView.delegate = self
        }
        
        
        drawInheritanceLines()
        drawUsageLines()
    }
    
    private func drawInheritanceLines() {
        for (key, inheritedDecls) in inheritanceMap {
            
            guard let nodeView = nodeIndex[key] else { continue }
            let inheritedNodes = Array(inheritedDecls)
                
            inheritedNodes.compactMap { node in
                
                guard !nodeView.outgoingNodes.contains(node) else { return nil }
                
                let path = makeArrowPath(from: node, to: nodeView)
                let line = DashedLine(path: path.cgPath)
                node.incomingLines.append(line)
                nodeView.outgoingLines.append(line)
                nodeView.outgoingNodes.append(node)
                node.incomingNodes.append(nodeView)
                return line
            }
            .forEach { contentView.layer?.addSublayer($0) }
        }
    }
    
    private func drawUsageLines() {
        for (key, usageDecls) in usageMap {
            
            guard let nodeView = nodeIndex[key] else { continue }
            let usageNodes = Array(usageDecls)
            
            usageNodes.compactMap { node in
                
                guard !nodeView.outgoingNodes.contains(node) else { return nil }
                
                let path = makeArrowPath(from: node, to: nodeView)
                let line = SolidLine(path: path.cgPath)
                node.incomingLines.append(line)
                nodeView.outgoingLines.append(line)
                nodeView.outgoingNodes.append(node)
                node.incomingNodes.append(nodeView)
                return line
            }
            .forEach { contentView.layer?.addSublayer($0) }
        }
    }
    
    func makeArrowPath(from startNode: DeclarationNodeView,
                       to endNode: DeclarationNodeView) -> ArrowPath {
        
        var startEndAngle = atan((endNode.center.y - startNode.center.y) / (endNode.center.x - startNode.center.x)) + ((endNode.center.x - startNode.center.x) < 0 ? CGFloat.pi : 0)
        let degreeToRadian = CGFloat.pi / 180
        if startEndAngle < 0 {
            startEndAngle = 360 * degreeToRadian + startEndAngle
        }

        let edgePoint = endNode.findEdgePoint(angle: startEndAngle)
        let computedEdge = CGPoint(x: endNode.center.x+edgePoint.x, y: endNode.center.y+edgePoint.y)
        return ArrowPath(start: startNode.center, end: computedEdge)
    }
    
    
    // MARK: DeclarationNodeViewDelegate
    
    func declarationNodeViewMouseDidDrag(_ nodeView: DeclarationNodeView) {
        
        zip(nodeView.outgoingNodes, nodeView.outgoingLines).forEach { node, line in
            line.path = makeArrowPath(from: node, to: nodeView).cgPath
        }
        zip(nodeView.incomingNodes, nodeView.incomingLines).forEach { node, line in
            line.path = makeArrowPath(from: nodeView, to: node).cgPath
        }
    }
}

