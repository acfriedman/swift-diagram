//
//  RelationshipMapper.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 8/5/21.
//

import Foundation
import AppKit

class RelationshipMapper {
    
    var isAddingRelationship: Bool = false
    
    private let canvasView: CanvasView!
    
    private var nodeIndex: [String: DeclarationNodeView] = [:]
    
    private var inheritanceMap: [String: Set<DeclarationNodeView>] = [:]
    
    private var usageMap: [String: Set<DeclarationNodeView>] = [:]
    
    private var editingArrow: CAShapeLayer?
    
    private var mouseMovedMonitor: Any?
    
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
    
    func makeArrowPath(from startNode: NSView,
                       to endNode: NSView) -> ArrowPath {
        
        var startEndAngle = atan((endNode.center.y - startNode.center.y) / (endNode.center.x - startNode.center.x)) + ((endNode.center.x - startNode.center.x) < 0 ? CGFloat.pi : 0)
        let degreeToRadian = CGFloat.pi / 180
        if startEndAngle < 0 {
            startEndAngle = 360 * degreeToRadian + startEndAngle
        }
        
        let edgePoint = endNode.findEdgePoint(angle: startEndAngle)
        let computedEdge = CGPoint(x: endNode.center.x+edgePoint.x, y: endNode.center.y+edgePoint.y)
        return ArrowPath(start: startNode.center, end: computedEdge)
    }
    
    var fromEditNode: NodeViewMappable?
    
    func addRelationship(to toView: NodeViewMappable) {
        guard isAddingRelationship,
        let editingArrow = editingArrow else {
            fatalError("ERROR: Attempting to add relationship but isAddingRelationship == false")
        }
        
        guard let fromEditNode = fromEditNode else {
            fatalError("ERROR: Attempting to add relationship but fromEditNode == nil")
        }
        
        
        let arrowPath = makeArrowPath(from: fromEditNode, to: toView)
        editingArrow.path = arrowPath.cgPath
        
        fromEditNode.addIncomingLine(editingArrow)
        toView.addOutgoingLine(editingArrow)
        toView.addOutgoingNode(fromEditNode)
        fromEditNode.addIncomingNode(toView)
        
        isAddingRelationship = false
        NSEvent.removeMonitor(mouseMovedMonitor)
        self.editingArrow = nil
        self.fromEditNode = nil
    }
    
    func startEditing(_ relationship: RelationshipType, for view: NodeViewMappable) {
        
        isAddingRelationship = true
        fromEditNode = view
        
        func addEditingSolidArrow() {
            
            let mouseLocation = self.canvasView.documentView!.window!.mouseLocationOutsideOfEventStream
            let mousePoint = self.canvasView.documentView!.convert(mouseLocation, from: nil)
            
            let relationshipLine: CAShapeLayer
            let arrowPath: NSBezierPath
            switch relationship {
            case .uses:
                arrowPath = ArrowPath(start: view.center, end: mousePoint)
                relationshipLine = SolidLine(path: arrowPath.cgPath)
            case .usedBy:
                arrowPath = ArrowPath(start: mousePoint, end: view.center)
                relationshipLine = SolidLine(path: arrowPath.cgPath)
            case .child:
                arrowPath = ArrowPath(start: mousePoint, end: view.center)
                relationshipLine = DashedLine(path: arrowPath.cgPath)
            case .parent:
                arrowPath = ArrowPath(start: mousePoint, end: view.center)
                relationshipLine = DashedLine(path: arrowPath.cgPath)
            }
            
            
            if let editingArrow = self.editingArrow {
                editingArrow.path = arrowPath.cgPath
                return
            }
            
            self.editingArrow = relationshipLine
            self.canvasView.documentView?.layer?.insertSublayer(self.editingArrow!, at: 0)
        }
        
        addEditingSolidArrow()
        
        mouseMovedMonitor = NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.mouseMoved, handler: { event in
            addEditingSolidArrow()
            return event
        })
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            
            guard let self = self,
                  let mouseMovedMonitor = self.mouseMovedMonitor else {
                return event
            }
            
            if event.keyCode == 53 {
                NSEvent.removeMonitor(mouseMovedMonitor)
                self.editingArrow?.removeFromSuperlayer()
                self.editingArrow = nil
                self.mouseMovedMonitor = nil
                self.isAddingRelationship = false
                self.fromEditNode = nil
            }
            
            return event
        }
    }
}

