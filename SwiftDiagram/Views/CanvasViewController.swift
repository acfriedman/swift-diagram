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
    
    private var coordinator: CanvasCoordinator!
    
    private var relationshipMapper: RelationshipMapper!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        makeContentView()
        makeCanvasView()
        
        coordinator = CanvasCoordinator(contentView: contentView)
        relationshipMapper = RelationshipMapper(contentView: contentView)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        FilePicker.presentModal(completion: { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let urls):
                do {
                    
                    let nodes = try SwiftViewer.parse(urls)
                    let nodeViews = self.makeNodeViews(from: nodes)
                    self.canvasView.nodeViews = nodeViews
                    self.coordinator.coordinate(nodeViews)
                    self.relationshipMapper.map(nodeViews)
                    
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
        
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown, handler: myKeyDownEvent)
    }
    
    func myKeyDownEvent(event: NSEvent) -> NSEvent {
        if event.keyCode == 51 {
            canvasView.selectedNodes.forEach { $0.remove() }
        }
        return event
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
    
    private func makeNodeViews(from nodes: [DeclarationNode]) -> [DeclarationNodeView] {
        return nodes.map {
            let frame = CGRect(x: 0, y: 0, width: $0.displayWidth, height: $0.displayHeight)
            return DeclarationNodeView(frame: frame, $0)
        }
    }
}

