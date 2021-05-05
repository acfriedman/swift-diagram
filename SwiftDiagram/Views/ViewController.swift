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

        FilePicker.presentModal { result in
            switch result {
            case .success(let url):
                do {
                    try SwiftViewer().parse(url)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

