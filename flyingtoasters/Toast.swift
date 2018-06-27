//
//  Toaster.swift
//  flyingtoasters
//
//  Created by James Miller on 6/25/18.
//  Copyright © 2018 jamesmiller.io. All rights reserved.
//

import Foundation
import ScreenSaver

public class Toast : SpriteProtocol {
    let bundle = Bundle.init(identifier: "io.jamesmiller.flyingtoasters")!
    
    var image: NSImage
    var point: CGPoint
    var bounds: CGRect
    var speed: CGPoint = CGPoint(x: 1, y: 1)
    var isForeground: Bool = false
    
    init(bounds: CGRect) {
        self.image = NSImage(contentsOfFile: self.bundle.pathForImageResource("toast.gif")!)!
        self.bounds = bounds
        self.point = CGPoint(x: Int(arc4random_uniform(UInt32(bounds.width + self.image.size.width))), y: Int(arc4random_uniform(UInt32(bounds.height + self.image.size.height))))
        self.speed = self.generateRandomSpeed()
        self.isForeground = arc4random_uniform(UInt32(2)) == 1
    }
    
    func draw() {
        self.image.draw(at: self.point, from: NSZeroRect, operation: .sourceOver, fraction: 1)
    }
    
    func update(delta: CGFloat) {
        self.point.x -= self.speed.x * delta
        self.point.y -= self.speed.y * delta
        
        if((self.point.x + self.image.size.width) < 0 || (self.point.y + self.image.size.height) < 0) {
            self.reset(bounds: self.bounds)
        }
    }
    
    func reset(bounds: CGRect) {
        let startTop = arc4random_uniform(2) == 0
        
        //Reset location
        if(startTop) {
            self.point = CGPoint(x: Int(arc4random_uniform(UInt32(bounds.width))), y: Int(bounds.height + self.image.size.height))
        } else {
            self.point = CGPoint(x: Int(bounds.width + self.image.size.width), y: Int(arc4random_uniform(UInt32(bounds.height))))
        }
        
        //Change the speed
        self.speed = self.generateRandomSpeed()
        
        //Change the z-index
        self.isForeground = arc4random_uniform(UInt32(2)) == 1
    }
    
    func generateRandomSpeed() -> CGPoint {
        let maxHoriontalSpeed = 72.0
        let minHorizontalSpeed = 27.0
        let ratio = Double(minHorizontalSpeed / maxHoriontalSpeed)
        let xSpeed = Double(arc4random_uniform(UInt32(maxHoriontalSpeed - minHorizontalSpeed))) + minHorizontalSpeed
        
        return CGPoint(x: xSpeed, y: Double(xSpeed) * ratio)
    }
}
