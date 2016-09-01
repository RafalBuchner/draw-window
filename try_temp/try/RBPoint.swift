//
//  RBPoint.swift
//  try
//
//  Created by Rafal Buchner on 01.09.2016.
//  Copyright © 2016 Rafal Buchner. All rights reserved.
//

import Cocoa

class RBPoint: NSObject {
    var x: CGFloat
    var y: CGFloat
    var selected: Bool = false
    
    init(x: CGFloat, y: CGFloat) {
        
        self.x = x
        self.y = y
        
    }
    
    func point() -> NSPoint {
//        let cgX = CGFloat(x)
//        let cgY = CGFloat(y)
        return NSPoint(x: x, y: y)
    }
}
