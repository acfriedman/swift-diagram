//
//  ViewController.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/5/21.
//

import Cocoa
import SwiftSyntax

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        FilePicker.presentModal(completion: { result in
            switch result {
            case .success(let url):
                do {
                    let sourceFileSyntax = try SyntaxParser.parse(url)
                    let viewer = SwiftViewer()
                    
                    let classes = viewer.extractClasses(from: sourceFileSyntax)
                    var xClassCoord = 100
                    var yClassCoord = 100
                    classes.forEach {
                        self.view.addSubview(self.makeRoundedBox(with: $0,
                                                               and: NSRect(x: xClassCoord,
                                                                           y: yClassCoord,
                                                                           width: 150,
                                                                           height: 100),
                                                               color: .green))
                        xClassCoord += 25
                        yClassCoord += 25
                    }
                    
                    let structs = viewer.extractStructs(from: sourceFileSyntax)
                    var xStructCoord = 200
                    var yStructCoord = 200
                    structs.forEach {
                        self.view.addSubview(self.makeRoundedBox(with: $0,
                                                               and: NSRect(x: xStructCoord,
                                                                           y: yStructCoord,
                                                                           width: 150,
                                                                           height: 100),
                                                               color: .blue))
                        xStructCoord += 25
                        yStructCoord += 25
                    }
                    
                    let protocols = viewer.extractProtocols(from: sourceFileSyntax)
                    var xProtocolCoord = 300
                    var yProtocolCoord = 300
                    protocols.forEach {
                        self.view.addSubview(self.makeRoundedBox(with: $0,
                                                               and: NSRect(x: xProtocolCoord,
                                                                           y: yProtocolCoord,
                                                                           width: 150,
                                                                           height: 100),
                                                               color: .purple))
                        xProtocolCoord += 25
                        yProtocolCoord += 25
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }

    private func makeRoundedBox(with name: String, and frame: NSRect, color: NSColor) -> RoundedTextView {
        let roundedTextView = RoundedTextView(frame: frame)
        roundedTextView.layer?.backgroundColor = color.cgColor
        roundedTextView.text = name
        return roundedTextView
    }
}

