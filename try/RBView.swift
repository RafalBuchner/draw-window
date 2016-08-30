//
//  Window.swift
//  try
//
//  Created by Rafal Buchner on 29.08.2016.
//  Copyright © 2016 Rafal Buchner. All rights reserved.
//

import Foundation
import Cocoa
import Darwin
func lenghtAB(A: NSPoint,B: NSPoint) -> Float{
    let sqA = pow((B.x - A.x), 2.0)
    let sqB = pow((B.y - A.y), 2.0)
    let sqC = sqA + sqB
    if sqC > 0 {
        let lengthAB = sqrt(sqC)
        return Float(lengthAB)
    } else {
        return 0
    }
}

class RBView: NSView {
    //    var mouseLocation: NSPoint {
    //        return NSEvent.mouseLocation()
    //    }
    var mouseLoc: NSPoint = NSPoint() //co zrobić aby mouseLoc przejmował wartość od parametru mouseDown? // ODP: self.needsDisplay w metodzie
    var mouseClickedByUser: Bool = false // sprawdza, czy został kliknięty LMB
    var mouseDraggedByUser: Bool = false // sprawdza, czy LMB został przeciągnięty
    
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
        //        Swift.print( "1) MouseMoved Location X,Y = \(theEvent.locationInWindow)" )
        
        mouseLoc = theEvent.locationInWindow
        self.needsDisplay = true /// niezbędne do przekazywania mouseLoc do ogólnej wartości
        
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        //        Swift.print( "2) MouseDragged Location X,Y = \(theEvent.locationInWindow)" )
        
        mouseLoc = theEvent.locationInWindow
        mouseDraggedByUser = true
        self.needsDisplay = true /// niezbędne do przekazywania mouseLoc do ogólnej wartości
        
    }
    
    override func mouseDown(theEvent : NSEvent) {
        
        Swift.print( "3) MouseDown Location X,Y = \(theEvent.locationInWindow)" )
        
        mouseClickedByUser = true
        self.needsDisplay = true
    }
    
    override func rightMouseDown(theEvent : NSEvent) {
        
        Swift.print( "4) RightMouseDown Location X,Y = \(theEvent.locationInWindow)" )
        
    }
    
    override func drawRect(dirtyRect: NSRect) {
        
        /// RB: rysuje tło
        NSColor.grayColor().set()
        NSRectFill(dirtyRect)
        /// Rysuje kursor
        NSColor.redColor().set()
        NSRectFill(NSMakeRect(mouseLoc.x-2.5, mouseLoc.y-2.5, 5, 5))
        
        
        ///bezier
        
        // setting control points
        var myStartPoint = NSPoint(x: 50 , y: 50)
        var myControlPoint1 = NSPoint(x: 250, y: 250)
        var myControlPoint2 = NSPoint(x: 350, y: 350)
        var myEndPoint = NSPoint(x: 50 , y: 100)
        let controlPoints = [myStartPoint, myControlPoint1, myControlPoint2, myEndPoint]
        
        NSColor.blueColor().set()
        let path = NSBezierPath()
        path.moveToPoint(myStartPoint)
        path.curveToPoint(myEndPoint, controlPoint1: myControlPoint1, controlPoint2: myControlPoint2)
        path.stroke()
        
        //draws controlPoints as circles
        for point in controlPoints {
            let xCor = point.x - 5
            let yCor = point.y - 5
            
            if point == myEndPoint || point == myStartPoint{
                NSColor.blueColor().set()
            } else {
                NSColor.yellowColor().set()
            }
            
            let rect = NSRect(origin: NSPoint(x: xCor, y: yCor), size: CGSize(width: 10, height: 10))
            let circle = NSBezierPath(roundedRect: rect, xRadius: 5, yRadius: 5)
            circle.stroke()
            NSColor.grayColor().set()
            circle.fill()
        }
        
        /// ciągnięcie
        
        if mouseDraggedByUser {
            for point in controlPoints {
                if lenghtAB(mouseLoc, B: point) < 10.0{
                    Swift.print("!!!!!!!!!!! \(point)")
                    let xCor = point.x - 5
                    let yCor = point.y - 5
                    
                    NSColor.redColor().set()
                    
                    
                    let rect = NSRect(origin: NSPoint(x: xCor, y: yCor), size: CGSize(width: 10, height: 10))
                    let circle = NSBezierPath(roundedRect: rect, xRadius: 5, yRadius: 5)
                    circle.fill()
                    
                    ////bardzo dziadowskie rozwiązanie problemu:
                    
                    if point == myStartPoint{
                        Swift.print("My Start Point")
                        myStartPoint.x = mouseLoc.x
                        myStartPoint.y = mouseLoc.y
                    
                    }
//                    case myControlPoint1:
//                        myControlPoint1.x = mouseLoc.x
//                        myControlPoint1.y = mouseLoc.y
//                        
//                    case myControlPoint2:
//                        myControlPoint2.x = mouseLoc.x
//                        myControlPoint2.y = mouseLoc.y
//                    case myEndPoint:
//                        myEndPoint.x = mouseLoc.x
//                        myEndPoint.y = mouseLoc.y
//                    default:
//                        ()
//                    }
                    /// bardzo dziadowskie rozwiązanie problemu…
                }
            }
            
            
            mouseDraggedByUser = false
        }
        
        
        
        
        
    }
}