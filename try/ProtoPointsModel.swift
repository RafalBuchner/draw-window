//
//  ProtoPointsModel.swift
//  try
//
//  Created by Rafal Buchner on 01.09.2016.
//  Copyright © 2016 Rafal Buchner. All rights reserved.
//

import Foundation
class ProtoPointsModel {
 
    var myStartPoint    = RBPoint(x: 50+200,  y: 50+200+200, indexNum: 1)
    var myControlPoint1 = RBPoint(x: 50+30+200,  y: 250, indexNum: 2)
    var myControlPoint2 = RBPoint(x: 400-30+200, y: 250+200, indexNum: 3)
    var myEndPoint      = RBPoint(x: 400+200, y: 50+200, indexNum: 4)

    var controlPoints: [RBPoint] {
        get {
            return [myStartPoint, myControlPoint1, myControlPoint2, myEndPoint]
        }
    }
}