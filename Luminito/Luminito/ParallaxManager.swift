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
    let randomGen = RandomGenerator()
    
    var bg: SKSpriteNode?
    var bg1: SKSpriteNode?
    
    var bg2: SKSpriteNode?
    var bg3: SKSpriteNode?
    
    func startBackGroundParallaxSmallStars(view: SKView, sprite: String, zPosition: CGFloat) {
        
        //FIRST SHOWN IN THE SCREEN
        bg = SKSpriteNode(imageNamed: sprite)
        bg?.size = CGSize(width: (view.scene?.size.width)!, height: (view.scene?.size.height)!)
        bg?.position = CGPoint(x: (view.scene?.size.width)! * 0.5, y: (view.scene?.size.height)! * 0.5)
        view.scene?.addChild(bg!)
        bg?.zPosition = zPosition
        
        //NEXT SHOWN IN THE SCREEN
        bg1 = SKSpriteNode(imageNamed: sprite)
        bg1?.size = CGSize(width: (view.scene?.size.width)!, height: (view.scene?.size.height)!)
        bg1?.position = CGPoint(x: (view.scene?.size.width)! * 1.5, y: (view.scene?.size.height)! * 0.5)
        view.scene?.addChild(bg1!)
        bg1?.zPosition = zPosition
        
        bg?.alpha = 0.4
        bg1?.alpha = 0.4
        
        
    }
    
    func startBackGroundParallaxMediumSmall(view: SKView, sprite: String, zPosition: CGFloat) {
        
        //FIRST SHOWN IN THE SCREEN
        bg2 = SKSpriteNode(imageNamed: sprite)
        bg2?.size = CGSize(width: (view.scene?.size.width)!, height: (view.scene?.size.height)!)
        bg2?.position = CGPoint(x: (view.scene?.size.width)! * 0.5, y: (view.scene?.size.height)! * 0.5)
        view.scene?.addChild(bg2!)
        bg2?.zPosition = zPosition
        
        //NEXT SHOWN IN THE SCREEN
        bg3 = SKSpriteNode(imageNamed: sprite)
        bg3?.size = CGSize(width: (view.scene?.size.width)!, height: (view.scene?.size.height)!)
        bg3?.position = CGPoint(x: (view.scene?.size.width)! * 1.5, y: (view.scene?.size.height)! * 0.5)
        view.scene?.addChild(bg3!)
        bg3?.zPosition = zPosition
        
    }
    
    func moveParallaxSmallStars(velocity: CGFloat) {
        self.bg?.position = CGPoint(x: (bg?.position.x)! - velocity, y: (bg?.position.y)!)
        self.bg1?.position = CGPoint(x: (bg1?.position.x)! - velocity, y: (bg1?.position.y)!)

        
        if velocity < 0 {
            if ((bg?.position.x)! > (1.5 * (bg?.size.width)!)) {
                bg?.position = CGPoint(x: (bg1?.position.x)! - (bg1?.size.width)!, y: (bg?.position.y)!)
            }
            
            if ((bg1?.position.x)! > (1.5 * (bg1?.size.width)!)) {
                bg1?.position = CGPoint(x: (bg?.position.x)! - (bg?.size.width)!, y: (bg1?.position.y)!)
            }
        } else {
            if ((bg?.position.x)! < (-0.5 * (bg?.size.width)!)) {
                bg?.position = CGPoint(x: (bg1?.position.x)! + (bg1?.size.width)!, y: (bg?.position.y)!)
            }
            
            if ((bg1?.position.x)! < (-0.5 * (bg1?.size.width)!)) {
                bg1?.position = CGPoint(x: (bg?.position.x)! + (bg?.size.width)!, y: (bg1?.position.y)!)
            }
        }
        
    }
    
    func moveParallaxSmallMedium(velocity: CGFloat) {
        
        self.bg2?.position = CGPoint(x: (bg2?.position.x)! - velocity, y: (bg2?.position.y)!)
        self.bg3?.position = CGPoint(x: (bg3?.position.x)! - velocity, y: (bg3?.position.y)!)
        
        
        if velocity < 0 {
            
            if ((bg2?.position.x)! > (1.5 * (bg2?.size.width)!)) {
                
                bg2?.position = CGPoint(x: (bg3?.position.x)! - (bg3?.size.width)!, y: (bg2?.position.y)!)
            }
            
            if ((bg3?.position.x)! > (1.5 * (bg3?.size.width)!)) {
                bg3?.position = CGPoint(x: (bg2?.position.x)! - (bg2?.size.width)!, y: (bg3?.position.y)!)
            }
            
        } else {
            if ((bg2?.position.x)! < (-0.5 * (bg2?.size.width)!)) {
                bg2?.position = CGPoint(x: (bg3?.position.x)! + (bg3?.size.width)!, y: (bg2?.position.y)!)
            }
            
            if ((bg3?.position.x)! < (-0.5 * (bg3?.size.width)!)) {
                bg3?.position = CGPoint(x: (bg2?.position.x)! + (bg2?.size.width)!, y: (bg3?.position.y)!)
            }
        }
    }
    
    func startCelestialBody(view: SKView, sprite: String, width: CGFloat, height: CGFloat, duration: TimeInterval, zPosition: CGFloat) {
        
        if sprite == "nebula" {
            startNebula(view: view, sprite: sprite, width: width, height: height, duration: duration, zPosition: zPosition)
        } else if sprite == "Sun" {
            startSun(view: view, sprite: sprite, width: width, height: height, duration: duration, zPosition: zPosition)
        } else {
            startPlanet(view: view, sprite: sprite, width: width, height: height, duration: duration, zPosition: zPosition)
        }
        
    }
    
    //MARK: - Manager internal methods and CelestialBody methods
    
    func startNebula(view: SKView, sprite: String, width: CGFloat, height: CGFloat, duration: TimeInterval, zPosition: CGFloat) {
        
        let body = SKSpriteNode(imageNamed: sprite)
        body.name = "nebula"
        body.size = CGSize(width: width, height: height)
        body.position = CGPoint(x: (((view.scene?.size.width)! * 0.5) + (width * 0.5)), y: 0)
        view.scene?.addChild(body)
        body.zPosition = zPosition
        
        body.lightingBitMask = 1
        body.shadowCastBitMask = 0
        body.shadowedBitMask = 1
        
        body.alpha = 0
        
        let action = SKAction.move(to: CGPoint(x:((view.scene?.size.width)! * 0.7),y:0), duration: duration)
        let fade = SKAction.fadeAlpha(to: 0.8, duration: 10)
        self.isNebulaInScreen = true
        body.run(action) {
            
            body.run(fade, completion: {
                self.stormAnimation(node: body)
            })
            
            let point = CGPoint(x: (-((view.scene?.size.width)! * 0.5)), y: CGFloat(0))
            let action2 = SKAction.move(to: point, duration: duration)
            
            let point2 = CGPoint(x: -((view.scene?.size.width)! * 1.2), y: 0)
            let action3 = SKAction.move(to: point2, duration: duration)
            
            let fadeOut = SKAction.fadeAlpha(to: 0, duration: 10)
            
            body.run(action2) {
                
                body.run(action3)
                body.run(fadeOut) {
                    self.isNebulaInScreen = false
                }
            }
        }
        
    }
    
    func startPlanet(view: SKView, sprite: String, width: CGFloat, height: CGFloat, duration: TimeInterval, zPosition: CGFloat) {
        
        let body = SKSpriteNode(imageNamed: sprite)
        body.size = CGSize(width: width, height: height)
        body.position = CGPoint(x: (((view.scene?.size.width)!) + (width * 0.5)), y: (view.scene?.size.height)! * 0.5)
        view.scene?.addChild(body)
        body.zPosition = zPosition
        
        body.alpha = 0.9
        
        let action = SKAction.move(to: CGPoint(x:-((view.scene?.size.width)! * 0.7),y:(view.scene?.size.height)! * 0.5), duration: duration)
        
        body.run(action) {
            body.removeFromParent()
        }
        
    }
    
    func startSun(view: SKView, sprite: String, width: CGFloat, height: CGFloat, duration: TimeInterval, zPosition: CGFloat) {
        
        let body = SKSpriteNode(imageNamed: sprite)
        body.size = CGSize(width: width, height: height)
        body.position = CGPoint(x: (((view.scene?.size.width)! * 0.5) + (width * 0.5)), y: 0)
        view.scene?.addChild(body)
        body.zPosition = zPosition
        
        body.alpha = 0.9
        
        let action = SKAction.move(to: CGPoint(x:((view.scene?.size.width)! * 0.4),y:(view.scene?.size.height)! * 0.5), duration: duration)
        
        body.run(action) {
            body.removeFromParent()
        }
    }
    
    //MARK: - Animations
    
    func stormAnimation(node: SKNode) {
        
        var lights:[SKLightNode] = []
        let x = self.randomGen.generateRandomNumber(min: -250, max: 400)
        let y = self.randomGen.generateRandomNumber(min: -300, max: 300)
        
        let a1 = SKAction.run {
            let light = SKLightNode()
            light.categoryBitMask = 1
            light.falloff = 1
            light.ambientColor = SKColor.darkGray
            light.isEnabled = true
            light.position = CGPoint(x: x, y: y)
            lights.append(light)
            node.addChild(light)
        }
        
        let a2 = SKAction.wait(forDuration: 0.1)
        
        let a3 = SKAction.run {
            lights.last?.removeFromParent()
            lights.removeLast()
        }
        
        let acts = [a1,a2,a1,a2,a1,a2,a3,a2,a3,a1,a3,a3]
        let seq = SKAction.sequence(acts)
        
        let finalSeq = SKAction.sequence([seq,a2,a2,seq,seq])
        
        node.run(finalSeq)
        
    }
    
    
}
