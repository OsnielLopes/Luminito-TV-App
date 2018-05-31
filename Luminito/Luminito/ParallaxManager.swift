//
//  ParallaxManager.swift
//  Luminito
//
//  Created by Pedro Del Rio Ortiz on 30/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import Foundation
import SpriteKit

class ParallaxManager {
    
    var isNebulaInScreen = false
    
    func startBackGroundParallax(view: SKView, sprite: String, duration: TimeInterval, zPosition: CGFloat) {
        
        //FIRST SHOWN IN THE SCREEN
        let bg = SKSpriteNode(imageNamed: sprite)
        bg.size = CGSize(width: (view.scene?.size.width)!, height: (view.scene?.size.height)!)
        bg.position = CGPoint(x: 0, y: 0)
        view.scene?.addChild(bg)
        bg.zPosition = zPosition
        
        //NEXT SHOWN IN THE SCREEN
        let bg1 = SKSpriteNode(imageNamed: sprite)
        bg1.size = CGSize(width: (view.scene?.size.width)!, height: (view.scene?.size.height)!)
        bg1.position = CGPoint(x: (view.scene?.size.width)!, y: 0)
        view.scene?.addChild(bg1)
        bg1.zPosition = zPosition
        
        let p1 = CGPoint(x: 0, y: 0)
        let p2 = CGPoint(x: -(view.scene?.size.width)!, y: CGFloat(0))
        let p3 = CGPoint(x: (view.scene?.size.width)!, y: CGFloat(0))
        
        //BG FIRST ACTIONS
        let moveLeft1 = SKAction.move(to: p2, duration: duration)
        let moveRight1 = SKAction.move(to: p3, duration: 0)
        let firstAction:[SKAction] = [moveLeft1,moveRight1]
        let firstSeq = SKAction.sequence(firstAction)
        
        //BG FOREVER ACTIONS
        let moveCenter = SKAction.move(to: p1, duration: duration)
        let moveLeft = SKAction.move(to: p2, duration: duration)
        let moveRight = SKAction.move(to: p3, duration: 0)
        let actions:[SKAction] = [moveCenter,moveLeft,moveRight]
        let seq = SKAction.sequence(actions)
        
        let act = SKAction.repeatForever(seq)
        
        bg1.run(act)
        bg.run(firstSeq) {
            bg.run(act)
        }
        
    }
    
    func startCelestialBody(view: SKView, sprite: String, width: CGFloat, height: CGFloat, duration: TimeInterval, zPosition: CGFloat) {
        
        if sprite == "test" {
            startNebula(view: view, sprite: sprite, width: width, height: height, duration: duration, zPosition: zPosition)
        }

    }
    
    //MARK: - Manager internal methods
    
    func startNebula(view: SKView, sprite: String, width: CGFloat, height: CGFloat, duration: TimeInterval, zPosition: CGFloat) {
        
        let body = SKSpriteNode(imageNamed: sprite)
        body.size = CGSize(width: width, height: height)
        body.position = CGPoint(x: (((view.scene?.size.width)! * 0.5) + (width * 0.5)), y: 0)
        view.scene?.addChild(body)
        body.zPosition = zPosition
        
        body.lightingBitMask = 1
        body.shadowCastBitMask = 0
        body.shadowedBitMask = 1
        
        body.alpha = 0
        
        let action = SKAction.move(to: CGPoint(x:0,y:0), duration: 0)
        
        body.run(action) {
            let point = CGPoint(x: (-((view.scene?.size.width)! * 0.5) - (width * 0.5)), y: CGFloat(0))
            let action2 = SKAction.move(to: point, duration: duration)
            
            let fade = SKAction.fadeAlpha(to: 0.8, duration: 10)
            
            body.run(action2)
            body.run(fade)
        }
        
        let storm = SKLightNode()
        storm.categoryBitMask = 1
        storm.falloff = 0
        storm.ambientColor = SKColor.white
        storm.lightColor = SKColor.white
        storm.shadowColor = SKColor.black
        storm.position = CGPoint(x: 0, y: 0)
        view.scene?.addChild(storm)
        
    }
    
    
}
