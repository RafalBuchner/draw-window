//
//  ViewController.swift
//  try
//
//  Created by Rafal Buchner on 29.08.2016.
//  Copyright © 2016 Rafal Buchner. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var myLocation: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLocation.stringValue = "\(RBView().mouseLoc) :Wyświetlane z poziomu ViewController" //Nie wiem jak zacząć odświerzać aktualizację
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

