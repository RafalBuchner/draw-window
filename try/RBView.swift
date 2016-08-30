//
//  Window.swift
//  try
//
//  Created by Rafal Buchner on 29.08.2016.
//  Copyright © 2016 Rafal Buchner. All rights reserved.
//

import Foundation
import Cocoa
class RBView: NSView {
//    var mouseLocation: NSPoint {
//        return NSEvent.mouseLocation()
//    }
    var mouseLoc: NSPoint = NSPoint() //co zrobić aby mouseLoc przejmował wartość od parametru mouseDown? // ODP: self.needsDisplay w metodzie
    
//    @IBOutlet weak var positionLabel: NSTextField! // to nie działa jak jest  przypisanie wartości stringValue w MouseMoved. Tak naprawdę nie działa przypisanie stringValue w jakimkolwiek miejscu tej klasy. Pewnie bym musiał jakoś przenieść wartość eventu do controllera. Ale jak? tworzyłem już atrybut NSPoint wewnątrz klasy RBView. mouseMoved aktualizował ten punkt wraz z koordynacjami. potem tworzyłem obiekt tej klasy w controllerze, i label wyswietlal jedynie NSPoint(0,0)
    
    
    override func awakeFromNib() {
        /** muszę dowiedzieć się więcej o firstResponder. To co zrobiłem wynikało to z szukania po stackach i jutubach. 
         Jak rozumiem, awakeFromNib aktywuje się, gdy wskazany obiekt stanie się firstResponderem, wtedy tworzy się NSTrackingArea, której nadałem wielkość rect RBView.bounds, dodałem odpowiednie, interesujące mnie opcje jako aktywne[.InVisibleRect,dzięki któremu np po rozwinięciu okna dalej oblicza pozycje, .ActiveAlways ~ oczywiste, .MouseMoved-oczywiste], ownera jako RBView
         Dzięki niemu, mouseMoved ma po czym obliczać koordynaty**/
        
        let myArea = NSTrackingArea(rect: bounds, options: [.InVisibleRect, .ActiveAlways, .MouseMoved], owner: self, userInfo: nil)
        addTrackingArea(myArea)
        

    }
    
    override func mouseMoved(theEvent: NSEvent) {
        /// miestety wartosc nil. Nie dziala jakie kolwiek rozpakowywanie optional:
//        positionLabel.stringValue = "\(theEvent.locationInWindow)"
        Swift.print( "Mouse Location X,Y = \(theEvent.locationInWindow)" )
        mouseLoc = theEvent.locationInWindow
        self.needsDisplay = true /// niezbędne do przekazywania mouseLoc do ogólnej wartości
        
    }
    override func mouseDown(theEvent : NSEvent) {
        
        Swift.print("left mouse")
        Swift.print( "Mouse Location X,Y = \(theEvent.locationInWindow)" )
        
    }
    
    override func rightMouseDown(theEvent : NSEvent) {
        Swift.print("right mouse")
        Swift.print( "Mouse Location X,Y = \(theEvent.locationInWindow)" )
    }
    
    override func drawRect(dirtyRect: NSRect) {
        
        /// RB: rysuje tło
        NSColor.blueColor().set()
        NSRectFill(dirtyRect)
        
        NSColor.redColor().set()
        NSRectFill(NSMakeRect(mouseLoc.x-15, mouseLoc.y-15, 30, 30))
        
    }
}