//
//  ViewController.swift
//  SwiftDiagram
//
//  Created by Andrew Friedman on 5/5/21.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let roundedTextView = RoundedTextView(frame: NSRect(x: Int(view.frame.width)/2,
                                                      y: Int(view.frame.height)/2,
                                                      width: 100,
                                                      height: 100))
        roundedTextView.text = "Hello World"
        view.addSubview(roundedTextView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    private func makeClassBox(with name: String, and frame: NSRect) -> RoundedTextView {
        return RoundedTextView(frame: frame)
    }

}

