//
//  SetCardShapes.swift
//  SetCardGame
//
//  Created by Walters on 6/25/20.
//  Copyright © 2020 Richard Walters. All rights reserved.
//

import SwiftUI


struct SetDiamond: Shape {
    func path(in rect: CGRect) -> Path {
        let upperCenter = CGPoint(x: rect.midX, y: rect.minY)
        let lowerCenter = CGPoint(x: rect.midX, y: rect.maxY)
        let midLeft = CGPoint(x: rect.minX, y: rect.midY)
        let midRight = CGPoint(x: rect.maxX, y: rect.midY)
        var p = Path()
        p.move(to:  upperCenter)
        p.addLine(to: midRight)
        p.addLine(to: lowerCenter)
        p.addLine(to: midLeft)
        p.addLine(to: upperCenter)
        return p
    }
}



struct SetSquiggle: Shape {
    
    var topLeftRadius: CGFloat = 0.0 // top-left radius parameter
    var topRightRadius: CGFloat = 50.0 // top-right radius parameter
    var bottomLeftRadius: CGFloat = 50.0 // bottom-left radius parameter
    var bottomRightRadius: CGFloat = 0.0 // bottom-right radius parameter
    
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        // Make sure the radius does not exceed the bounds dimensions
        let tr = min(min(self.topRightRadius, h/2), w/2)
        let tl = min(min(self.topLeftRadius, h/2), w/2)
        let bl = min(min(self.bottomLeftRadius, h/2), w/2)
        let br = min(min(self.bottomRightRadius, h/2), w/2)
        var  p = Path()
        p.move(to: CGPoint(x: w / 2.0, y: 0))
        p.addLine(to: CGPoint(x: w - tr, y: 0))
        p.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        p.addLine(to: CGPoint(x: w, y: h - br))
        p.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        p.addLine(to: CGPoint(x: bl, y: h))
        p.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        p.addLine(to: CGPoint(x: 0, y: tl))
        p.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        p.addLine(to: CGPoint(x: w / 2.0, y: 0))
        return p
    }
    
}
