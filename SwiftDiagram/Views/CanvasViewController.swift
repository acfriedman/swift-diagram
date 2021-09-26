//
//  CanvasViewController.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/5/21.
//

import Cocoa
import SwiftSyntax
import SnapKit

class CanvasViewController: NSViewController, MainWindowControllerDelegate {
    
    var contentView: NSView!
    var canvasView: CanvasView!
    
    private var coordinator: CanvasCoordinator!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        makeContentView()
        makeCanvasView()
        
        coordinator = CanvasCoordinator(canvasView: canvasView)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        setWindowControllerDelegate()
        
        FilePicker.presentModal(completion: { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let urls):
                do {
                    self.coordinator.nodes = try SwiftViewer.parse(urls)
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
            coordinator.remove(canvasView.selectedNodes)
        }
        return event
    }
    
    // MARK: MainWindowControllerDelegate
    
    func mainWindowController(_ controller: MainWindowController, didSearchFor text: String) {
        do {
            try coordinator.plotNode(text)
        } catch {
            print("Failed to plot searched node \(text): \(error)")
        }
    }
    
    func mainWindowController(_ controller: MainWindowController, didSelectAdd construct: SwiftConstruct) {
        coordinator.plot(type: construct)
    }
    
    // MARK: Private Methods
    
    private func makeContentView() {
        contentView = NSView()
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = Color.offWhiteBackground.cgColor
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
    
    private func setWindowControllerDelegate() {
        guard let windowController = view.window?.windowController as? MainWindowController else {
            assertionFailure("The view's window is not of type MainWindowController")
            return
        }
        windowController.delegate = self
    }
}

