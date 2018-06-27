//
//  SpriteProtocol.swift
//  flyingtoasters
//
//  Created by James Miller on 6/25/18.
//  Copyright © 2018 jamesmiller.io. All rights reserved.
//

import Foundation
import ScreenSaver

protocol SpriteProtocol {
    var image: NSImage { get }
    var point: CGPoint { get }
    var isForeground: Bool { get }
    
    func draw()
    func update(delta: CGFloat)
}
