//
//  Toaster.swift
//  flyingtoasters
//
//  Created by James Miller on 6/26/18.
//  Copyright © 2018 jamesmiller.io. All rights reserved.
//

import Foundation
import ScreenSaver

public class Toaster : SpriteProtocol {
    let bundle = Bundle.init(identifier: "io.jamesmiller.flyingtoasters")!
    let drawPerFrame: Int = 6
    let frameRate: Int = 24
    
    var image: NSImage
    var point: CGPoint
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0.0, height: 0.0)
    var bounds: CGRect
    var frames: [CGRect] = [CGRect]()
    var currentFrameCount: Int = 0
    var speed: CGPoint = CGPoint(x: 1, y: 1)
    var direction: Int = 1
    var isForeground: Bool = false
    
    init(bounds: CGRect) {
        self.bounds = bounds
        self.image = NSImage(contentsOfFile: self.bundle.pathForImageResource("toaster.gif")!)!
        self.frame = CGRect(x: 0, y: 0, width: self.image.size.width / 4, height: self.image.size.height)
        self.point = CGPoint(x: Int(arc4random_uniform(UInt32(bounds.width + self.image.size.width))), y: Int(arc4random_uniform(UInt32(bounds.height + self.image.size.height))))
        
        //Generate our animation frames
        self.generateFrames() 
        
        //Use one of the generated frames
        self.frame = self.frames[0]
        self.currentFrameCount = Int(arc4random_uniform(UInt32(self.frameRate)))
        self.speed = self.generateRandomSpeed()
    }
    
    func draw() {

        let frameIndex = self.currentFrameCount / self.drawPerFrame
        
        self.image.draw(at: self.point, from: self.frames[frameIndex], operation: .sourceOver, fraction: 1)

        if self.currentFrameCount == self.frameRate - 1  {
            //self.currentFrameCount = 0
            self.direction = -1
        } else if self.currentFrameCount == 1 {
            self.direction = 1
        }
        
        self.currentFrameCount += direction
    }
    
    func update(delta: CGFloat) {
        self.point.x -= self.speed.x * delta
        self.point.y -= self.speed.y * delta
        
        if(self.point.x + self.image.size.width < 0 || self.point.y + self.image.size.height < 0) {
            self.reset(bounds: self.bounds)
        }
    }
    
    func reset(bounds: CGRect) {
        let startTop = arc4random_uniform(2) == 0
        
        if(startTop) {
            self.point = CGPoint(x: Int(arc4random_uniform(UInt32(bounds.width))), y: Int(bounds.height + self.image.size.height))
        } else {
            self.point = CGPoint(x: Int(bounds.width + self.image.size.width), y: Int(arc4random_uniform(UInt32(bounds.height))))
        }
        
        //Change the speed
        self.speed = self.generateRandomSpeed()
    }
    
    func generateFrames() {
        let width = self.image.size.width / 4
        self.frames = [
            CGRect(x: width * 0, y: 0, width: width, height: self.image.size.height),
            CGRect(x: width * 1, y: 0, width: width, height: self.image.size.height),
            CGRect(x: width * 2, y: 0, width: width, height: self.image.size.height),
            CGRect(x: width * 3, y: 0, width: width, height: self.image.size.height) ];
    }
    
    func generateRandomSpeed() -> CGPoint {
        let maxHoriontalSpeed = 72.0
        let minHorizontalSpeed = 27.0
        let ratio = Double(minHorizontalSpeed / maxHoriontalSpeed)
        let xSpeed = Double(arc4random_uniform(UInt32(maxHoriontalSpeed - minHorizontalSpeed))) + minHorizontalSpeed
        
        return CGPoint(x: xSpeed, y: Double(xSpeed) * ratio)
    }
}
