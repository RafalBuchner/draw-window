//
//  ViewController.swift
//  try
//
//  Created by Rafal Buchner on 29.08.2016.
//  Copyright © 2016 Rafal Buchner. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var window: Window!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        window.window?.acceptsMouseMovedEvents = true
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

