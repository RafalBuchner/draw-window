//
//  Window.swift
//  try
//
//  Created by Rafal Buchner on 29.08.2016.
//  Copyright © 2016 Rafal Buchner. All rights reserved.
//

import Foundation
import Cocoa
class Window: NSView {
    
    var mouseLocation: NSPoint {
        return NSEvent.mouseLocation()
    }
    
    
    override func mouseMoved(theEvent: NSEvent) {
        Swift.print( "Mouse Location X,Y = \(mouseLocation)" )
        Swift.print( "Mouse Location X = \(mouseLocation.x)" )
        Swift.print( "Mouse Location Y = \(mouseLocation.y)" )

    }
    override func mouseDown(theEvent : NSEvent) {
        Swift.print("left mouse")
    }
    
    override func rightMouseDown(theEvent : NSEvent) {
        Swift.print("right mouse")
    }
    
    override func drawRect(dirtyRect: NSRect) {

        /// RB: rysuje tło
        NSColor.blueColor().set()
        NSRectFill(dirtyRect)

        NSColor.redColor().set()
        NSRectFill(NSMakeRect(100, 100, 30, 30))
        
    }
}