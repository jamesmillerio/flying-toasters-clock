//
//  flyingtoasterView.swift
//  flyingtoasters
//
//  Created by James Miller on 6/25/18.
//  Copyright © 2018 jamesmiller.io. All rights reserved.
//

import Foundation
import ScreenSaver

class FlyingToastersView: ScreenSaverView {
    
    
    let dateFormatter = DateFormatter()
    let bundle = Bundle.init(identifier: "io.jamesmiller.flyingtoasters")!
    let maxToastsAndToasters: Int = 60
    let defaultFontSize: CGFloat = 300.0
    
    var deltaTime: TimeInterval?
    var previousTimestamp: Double = NSDate.timeIntervalSinceReferenceDate as Double
    var lastFrameTime: Double = 0.0
    var toastsAndToasters: [SpriteProtocol] = [SpriteProtocol]()
    var screenCenter: CGPoint = CGPoint(x: 0, y: 0)
    var mainAttributes: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key: AnyObject]()
    var currentTime: Double = NSDate.timeIntervalSinceReferenceDate as Double
    var timestamp: NSString = ""
    var screenFrame: NSRect
    
    override init?(frame: NSRect, isPreview: Bool) {
        
        self.screenFrame = frame
        
        super.init(frame: frame, isPreview: isPreview)
        
        self.dateFormatter.dateFormat = "h:mm:ss"
        self.configureScreenAttributes(frame: frame)
        self.spawnToastersAndToast()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        self.currentTime = NSDate.timeIntervalSinceReferenceDate as Double
        //self.deltaTime = CACurrentMediaTime() - self.previousTimestamp
        //self.previousTimestamp = CACurrentMediaTime()
        self.deltaTime = self.currentTime - self.previousTimestamp
        
        //self.timestamp = self.dateFormatter.string(from: self.currentTime) as NSString
        self.timestamp = self.dateFormatter.string(from: Date()) as NSString
        
        let timestampSize = timestamp.size(withAttributes: mainAttributes)
        
        //Set our new screen center
        self.screenCenter = CGPoint(x: (self.screenFrame.width - timestampSize.width) / 2, y: (self.screenFrame.height - timestampSize.height) / 2)
        
        //Draw the background
        for sprite in self.toastsAndToasters {
            if !sprite.isForeground {
                sprite.draw()
                sprite.update(delta: CGFloat(self.deltaTime!))
            }
        }
        
        //Draw the clock
        self.timestamp.draw(at: self.screenCenter, withAttributes: mainAttributes)
        
        //Draw the foreground
        for sprite in self.toastsAndToasters {
            if sprite.isForeground {
                sprite.draw()
                sprite.update(delta: CGFloat(self.deltaTime!))
            }
        }
        
        self.previousTimestamp = NSDate.timeIntervalSinceReferenceDate as Double
    }
    
    override func animateOneFrame() {
        setNeedsDisplay(bounds)
    }
    
    func spawnToastersAndToast() {
        
        for i in 0..<self.maxToastsAndToasters {
            let spawnToaster = i % 2 == 0
            
            if spawnToaster {
                //Make a toaster
                self.toastsAndToasters.append(Toaster(bounds: bounds))
            } else {
                //Make some toast
                self.toastsAndToasters.append(Toast(bounds: bounds))
            }
        }
        
        
    }
    
    func updateToastersAndToast(delta: Double) {
        for sprite in self.toastsAndToasters {
            //sprite.update(delta: CGFloat(abs(delta)))
            sprite.update(delta: CGFloat(delta))
        }
    }
    
    func configureScreenAttributes(frame: NSRect) {
        
        //Set some default attributes
        self.mainAttributes = [
            NSAttributedString.Key.font: NSFont.monospacedDigitSystemFont(ofSize: self.defaultFontSize, weight: NSFont.Weight.ultraLight),
            NSAttributedString.Key.foregroundColor: NSColor.white
        ];
        
        let timestamp = self.dateFormatter.string(from: Date()) as NSString
        let timestampSize = timestamp.size(withAttributes: mainAttributes)
        let widthPerFontSize = timestampSize.width / self.defaultFontSize
        let fontSize = (self.bounds.width * 0.75) / widthPerFontSize
        
        //Set our final font attributes
        self.mainAttributes = [
            NSAttributedString.Key.font: NSFont.monospacedDigitSystemFont(ofSize: fontSize, weight: NSFont.Weight.ultraLight),
            NSAttributedString.Key.foregroundColor: NSColor.white
        ];
    }
}
