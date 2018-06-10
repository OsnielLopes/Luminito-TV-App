//
//  RandomGenerator.swift
//  Luminito
//
//  Created by Pedro Del Rio Ortiz on 29/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import Foundation
import SpriteKit

class RandomGenerator {
    
    func generateRandomStar(view: SKView, minSize: Int, maxSize: Int) {
        
        let randomY = generateRandomNumber(min: Int(-((view.scene?.size.height)! * 0.5)), max: (Int((view.scene?.size.height)! * 0.5)))
        let randomX = generateRandomNumber(min: Int(((view.scene?.size.width)! * 0.52)), max: (Int((view.scene?.size.width)! * 0.8)))
        
        let ran2 = generateRandomNumber(min: minSize, max: maxSize)
        
        let s = SKShapeNode(circleOfRadius: CGFloat(ran2)/10)
        s.strokeColor = UIColor.white
        s.fillColor = UIColor.white
        s.position = CGPoint(x: randomX, y: randomY)
        view.scene?.addChild(s)
        
        let p = CGPoint(x: -((view.scene?.size.width)!) * 0.52, y: CGFloat(randomY))
        let act = SKAction.move(to: p, duration: 60)
        let act2 = SKAction.removeFromParent()
        
        let actions = [act,act2]
        let ac = SKAction.sequence(actions)
        s.run(ac)
        
    }
    
    func generateStars(view: SKView, minSize: Int, maxSize: Int, divisor: CGFloat, starsAmount: Int) -> [SKShapeNode] {
        
        var stars:[SKShapeNode] = []
        
        for _ in 1...starsAmount {
            
            let randomY = generateRandomNumber(min: Int(-((view.scene?.size.height)! * 0.5)), max: (Int((view.scene?.size.height)! * 0.5)))
            let randomX = generateRandomNumber(min: Int(-((view.scene?.size.width)! * 0.52)), max: (Int((view.scene?.size.width)! * 0.8)))
            
            let ran2 = generateRandomNumber(min: minSize, max: maxSize)
            
            let s = SKShapeNode(circleOfRadius: CGFloat(ran2)/divisor)
            s.strokeColor = UIColor.white
            s.fillColor = UIColor.white
            s.position = CGPoint(x: randomX, y: randomY)
            view.scene?.addChild(s)
            
            stars.append(s)
        }
        
        return stars
    }
    
    func generateRandomNumber(min: Int, max: Int) -> Int {
        let result = Int(arc4random_uniform(UInt32((max - min) + 1))) + min
        return result
    }
    
    
}
