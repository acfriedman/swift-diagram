//
//  RelationshipMapper.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 8/5/21.
//

import Foundation
import AppKit

class RelationshipMapper {
    
    private let canvasView: CanvasView!
    
    private var nodeIndex: [String: DeclarationNodeView] = [:]
    
    private var inheritanceMap: [String: Set<DeclarationNodeView>] = [:]
    
    private var usageMap: [String: Set<DeclarationNodeView>] = [:]
    
    init(canvasView: CanvasView) {
        self.canvasView = canvasView
    }
    
    func mapLines(_ nodes: [DeclarationNodeView]) {
        
        nodes.forEach { nodeView in
            let node = nodeView.declarationNode
            nodeIndex[node.name] = nodeView
            node.inheritance.forEach { inheritanceMap[$0, default: []].insert(nodeView) }
            node.usage.forEach { usageMap[$0, default: []].insert(nodeView) }
        }
        
        
        drawInheritanceLines()
        drawUsageLines()
    }
    
    func clearAllLines() {
        nodeIndex = [:]
        inheritanceMap = [:]
        usageMap = [:]
        nodeIndex.values.forEach { $0.removeLines() }
    }
    
    func updatePaths(for nodeView: DeclarationNodeView) {
        zip(nodeView.outgoingNodes, nodeView.outgoingLines).forEach { node, line in
            line.path = makeArrowPath(from: node, to: nodeView).cgPath
        }
        zip(nodeView.incomingNodes, nodeView.incomingLines).forEach { node, line in
            line.path = makeArrowPath(from: nodeView, to: node).cgPath
        }
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
            .forEach { canvasView.documentView?.layer?.addSublayer($0) }
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
            .forEach { canvasView.documentView?.layer?.addSublayer($0) }
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
    
    var editingArrow: CAShapeLayer?
    
    func startEditing(_ relationship: RelationshipType, for view: NSView) {
        
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.mouseMoved, handler: { [weak self] event in
            guard let self = self else {
                return event
            }
            
            let mousePoint = self.canvasView.documentView!.convert(event.locationInWindow, from: nil)
            print(mousePoint)
            let arrowPath = ArrowPath(start: view.center, end: mousePoint)
            
            if let editingArrow = self.editingArrow {
                editingArrow.path = arrowPath.cgPath
                return event
            }
            
            self.editingArrow = SolidLine(path: arrowPath.cgPath)
            self.canvasView.documentView?.layer?.insertSublayer(self.editingArrow!, at: 0)
            
            return event
        })
        
        switch relationship {
        case .uses:
            
            
            
            break
        case .usedBy:
            break
        case .child:
            break
        case .parent:
            break
        }
    }
}

