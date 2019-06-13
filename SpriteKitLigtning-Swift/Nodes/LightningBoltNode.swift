//
//  LightningBoltNode.swift
//  SpriteKitLigtning-Swift
//
//  Created by Andrey Gordeev on 28/10/14.
//  Copyright (c) 2014 Andrey Gordeev. All rights reserved.
//

import Foundation
import SpriteKit

var sHalfCircle = SKTexture()
var sLightningSegment = SKTexture()
var sSoundActions = [SKAction]()
var sShader = SKShader(fileNamed: "outlighting.fsh")
var hasInit = false

class LightningBoltNode: SKNode {
    
    var lifetime = 0.15
    var lineDrawDelay = 0.02
    var displaceCoefficient = 0.8
    var lineRangeCoefficient = 1.8
    var pathArray = [CGPoint]()
    
    init(startPoint: CGPoint, endPoint: CGPoint, lifetime: Double, lineDrawDelay: Double, displaceCoefficient: Double, lineRangeCoefficient: Double) {
        super.init()
        self.isUserInteractionEnabled = false
        self.lifetime = lifetime
        self.lineDrawDelay = lineDrawDelay
        self.displaceCoefficient = displaceCoefficient
        self.lineRangeCoefficient = lineRangeCoefficient
        self.drawBolt(startPoint: startPoint, endPoint: endPoint)
//        let soundAction = sSoundActions[Int(arc4random_uniform(UInt32(sSoundActions.count)))]
//        self.run(soundAction)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: Drawing bolt
    
    func drawBolt(startPoint: CGPoint, endPoint: CGPoint) {
        // Dynamically calculating displace
        let xRange = endPoint.x - startPoint.x
        let yRange = endPoint.y - startPoint.y
        let hypot = hypotf(fabsf(Float(xRange)), fabsf(Float(yRange)))
        // hypot/displace = 4/1
        let displace = hypot*Float(self.displaceCoefficient)
        
        pathArray.append(startPoint)
        self.createBolt(x1: startPoint.x, y1: startPoint.y, x2: endPoint.x, y2: endPoint.y, displace: Double(displace))
        
        
        for i in 0...pathArray.count-2{
            self.addLineToBolt(startPoint: pathArray[i], endPoint: pathArray[i+1], delay: Double(i)*self.lineDrawDelay)
        }
        
        let waitDuration = Double(pathArray.count - 1)*self.lineDrawDelay + self.lifetime
        let disappear = SKAction.sequence([SKAction.wait(forDuration: waitDuration), SKAction.fadeOut(withDuration: 0.25), SKAction.removeFromParent()])
        self.run(disappear)
    }
    
    func addLineToBolt(startPoint: CGPoint, endPoint: CGPoint, delay: Double) {
        let line = LightningLineNode(startPoint: startPoint, endPoint: endPoint)
        self.addChild(line)
        line.color = UIColor.red
        if (delay == 0) {
            line.draw()
        }
        else {
            let delayAction = SKAction.wait(forDuration: TimeInterval(delay))
            let draw = SKAction.run({ () -> Void in
                line.draw()
            })
            line.run(SKAction.sequence([delayAction,draw]))
        }
    }
    
    func createBolt(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, displace: Double) {
        if displace < self.lineRangeCoefficient {
            let point = CGPoint(x:x2, y:y2);
            self.pathArray.append(point)
        }
        else {
            var mid_x = Double(x2+x1)*0.5;
            var mid_y = Double(y2+y1)*0.5;
            mid_x += (Double(arc4random_uniform(100))*0.01-0.5)*displace;
            mid_y += (Double(arc4random_uniform(100))*0.01-0.5)*displace;
            let halfDisplace = displace*0.5
            self.createBolt(x1: x1, y1: y1, x2: CGFloat(mid_x), y2: CGFloat(mid_y), displace: halfDisplace)
            self.createBolt(x1: CGFloat(mid_x), y1: CGFloat(mid_y), x2: x2, y2: y2, displace: halfDisplace)
        }
    }
    
    class func loadSharedAssets(){
        if (!hasInit){
            sHalfCircle = SKTexture(imageNamed: "half_circle")
            sLightningSegment = SKTexture(imageNamed: "lightning_segment")
            hasInit = true
        }
    }
    
}
