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
    
    // setting control points
    var controlPoints = ProtoPointsModel().controlPoints
    //    var mouseLocation: NSPoint {
    //        return NSEvent.mouseLocation()
    //    }
    var mouseLoc: NSPoint = NSPoint()
    var mouseLocDragged: NSPoint = NSPoint() //co zrobić aby mouseLocDragged przejmował wartość od parametru mouseDown? // ODP: self.needsDisplay w metodzie
    var mouseClickedByUser: Bool = false // sprawdza, czy został kliknięty LMB
    var mouseDraggedByUser: Bool = false // sprawdza, czy LMB został przeciągnięty

    override func awakeFromNib() {
        /** muszę dowiedzieć się więcej o firstResponder. To co zrobiłem wynikało to z szukania po stackach i jutubach.
         Jak rozumiem, awakeFromNib aktywuje się, gdy wskazany obiekt stanie się firstResponderem, wtedy tworzy się NSTrackingArea, której nadałem wielkość rect RBView.bounds, dodałem odpowiednie, interesujące mnie opcje jako aktywne[.InVisibleRect,dzięki któremu np po rozwinięciu okna dalej oblicza pozycje, .ActiveAlways ~ oczywiste, .MouseMoved-oczywiste], ownera jako RBView
         Dzięki niemu, mouseMoved ma po czym obliczać koordynaty**/
        
        let myArea = NSTrackingArea(rect: bounds, options: [.InVisibleRect, .ActiveAlways, .MouseMoved], owner: self, userInfo: nil)
        addTrackingArea(myArea)
    }
    override var acceptsFirstResponder: Bool{
        // pozwala na korzystanie np. z keyboardEvents
        return true
    }
    
    override func mouseMoved(theEvent: NSEvent) {
        
        mouseLoc = theEvent.locationInWindow
        self.needsDisplay = true /// niezbędne do przekazywania wartości mouseLoc poza metodę
        
    }
    
    override func mouseDragged(theEvent: NSEvent) {

        mouseLoc = theEvent.locationInWindow
        
        for point in controlPoints {
            
            if lenghtAB(mouseLoc, B: point.point()) < 10.0{
                
                point.selected = true

            }
        }
        mouseLoc = theEvent.locationInWindow
        
        mouseDraggedByUser = true
        self.needsDisplay = true /// niezbędne do przekazywania mouseLoc do ogólnej wartości
        
    }
    
    override func mouseDown(theEvent : NSEvent) {
        Swift.print( "3) MouseDown Location X,Y = \(theEvent.locationInWindow)" )
        for point in controlPoints {
                if lenghtAB(mouseLoc, B: point.point()) < 10 {
                    point.selected = true
                } else {
                    point.selected = false
                }
            }

        mouseClickedByUser = true
        self.needsDisplay = true
    }

    override func rightMouseDown(theEvent : NSEvent) {
        
        Swift.print( "4) RightMouseDown Location X,Y = \(theEvent.locationInWindow)" )
        self.needsDisplay = true
    }
    
    
    
    override func keyDown(theEvent: NSEvent) {
        if (theEvent.keyCode == 2){
            // jabko + d
            /* gdy przyciśniesz jabko + d, wyzerujesz całą selekcję */
            for point in controlPoints{
                point.selected = false
                Swift.print("\(point) selected = \(point.selected)")
            }
        }
        if (theEvent.keyCode == 1){
            // jabko + d
            /* gdy przyciśniesz jabko + d, wyplówa status selekcji */
            for point in controlPoints{
                Swift.print("\(point) selected = \(point.selected)")
            }
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        
        /// RB: rysuje tło
        NSColor.grayColor().set()
        NSRectFill(dirtyRect)
        
        
        ///bezier

        
        NSColor.blueColor().set()
        let path = NSBezierPath()
        path.moveToPoint( controlPoints[0].point() )
        path.curveToPoint(
                           controlPoints[3].point(),
            controlPoint1: controlPoints[1].point(),
            controlPoint2: controlPoints[2].point())
        path.stroke()
        NSColor.yellowColor().set()
        let bars = NSBezierPath()
        bars.moveToPoint(controlPoints[0].point())
        bars.lineToPoint(controlPoints[1].point())
        bars.stroke()
        bars.moveToPoint(controlPoints[3].point())
        bars.lineToPoint(controlPoints[2].point())
        bars.stroke()
        
        //draws controlPoints as circles
        for point in controlPoints {
            let xCor = point.x - 5
            let yCor = point.y - 5
            
            if point == controlPoints[3] || point == controlPoints[0]{
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
        
        
        for point in controlPoints {
            if point.selected{
                
                /// zakolorowanie ciągniątego punktu na żółto
                let xCor = point.x - 5
                let yCor = point.y - 5
                
                NSColor.yellowColor().set()
                let rect = NSRect(origin: NSPoint(x: xCor, y: yCor), size: CGSize(width: 10, height: 10))
                let circle = NSBezierPath(roundedRect: rect, xRadius: 5, yRadius: 5)
                circle.fill()
                
            }
        }
        
        if mouseDraggedByUser {
            for point in controlPoints {

                
                if point.selected{
                    switch point {
                    case controlPoints[0]:
                        controlPoints[0].x = mouseLoc.x
                        controlPoints[0].y = mouseLoc.y
                        
                    case controlPoints[1]:
                        controlPoints[1].x = mouseLoc.x
                        controlPoints[1].y = mouseLoc.y
                        
                    case controlPoints[2]:
                        controlPoints[2].x = mouseLoc.x
                        controlPoints[2].y = mouseLoc.y
                        
                    case controlPoints[3]:
                        controlPoints[3].x = mouseLoc.x
                        controlPoints[3].y = mouseLoc.y
                        
                    default:
                        ()
                    }
                }
            }
            mouseDraggedByUser = false
        }
    }
}