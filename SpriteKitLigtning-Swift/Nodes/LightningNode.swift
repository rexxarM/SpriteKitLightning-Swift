//
//  LightningNode.swift
//  SpriteKitLigtning-Swift
//
//  Created by Andrey Gordeev on 28/10/14.
//  Copyright (c) 2014 Andrey Gordeev. All rights reserved.
//

import Foundation
import SpriteKit

class LightningNode: SKSpriteNode {
    
    var targetPoints = [CGPoint]();
    
    // Time between bolts (in seconds)
    let timeBetweenBolts = 0.15
    
    // Bolt lifetime (in seconds)
    let boltLifetime = 0.1
    
    // Line draw delay (in seconds). Set as 0 if you want whole bolt to draw instantly
    let lineDrawDelay = 0.00175
    
    // 0.0 - the bolt will be a straight line. >1.0 - the bolt will look unnatural
    let displaceCoefficient = 0.25
    
    // Make bigger if you want bigger line lenght and vice versa
    let lineRangeCoefficient = 1.8
    
    // MARK: - Life cycle
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size: size)
        LightningBoltNode.loadSharedAssets()
        self.isUserInteractionEnabled = true
        self.anchorPoint = CGPoint.zero
        self.size = size
    }

     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//            return
//        }
        for touch in touches{
            let locationInNode = touch.location(in: self)
            
            self.targetPoints.removeAll(keepingCapacity: false)
            self.targetPoints.append(locationInNode)
            self.startLightning(locationInNode)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let locationInNode = touch.location(in: self)
        
        self.targetPoints.removeAll(keepingCapacity: false)
        self.targetPoints.append(locationInNode)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.stopLightning()
    }
    
    // MARK: Lightning operating
    
    func startLightning(_ startPoint:CGPoint) {
        let wait = SKAction.wait(forDuration: timeBetweenBolts)
        let addLightning = SKAction.run { () -> Void in
//            let startPoint = CGPoint(x:self.frame.midX, y:self.frame.midY)
            for _ in 0...1{
                for targetPoint in self.targetPoints {
                    self.addBolt(startPoint: startPoint, endPoint: targetPoint)
                }
            }
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([addLightning, wait])), withKey: "lightning")
    }
    
    func stopLightning() {
        self.removeAction(forKey: "lightning")
    }
    
    func addBolt(startPoint: CGPoint, endPoint: CGPoint) {
        let bolt = LightningBoltNode(startPoint: startPoint, endPoint: endPoint, lifetime: self.boltLifetime, lineDrawDelay: self.lineDrawDelay, displaceCoefficient: self.displaceCoefficient, lineRangeCoefficient: self.lineRangeCoefficient)
        self.addChild(bolt)
    }
}
