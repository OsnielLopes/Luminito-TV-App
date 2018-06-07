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
    
    func startBackGroundParallax(view: SKView, sprite: String, duration: TimeInterval, zPosition: CGFloat) {
        
        //FIRST SHOWN IN THE SCREEN
        let bg = SKSpriteNode(imageNamed: sprite)
        bg.size = CGSize(width: (view.scene?.size.width)!, height: (view.scene?.size.height)!)
        bg.position = CGPoint(x: 0, y: (view.scene?.size.height)! * 0.5)
        view.scene?.addChild(bg)
        bg.zPosition = zPosition
        
        //NEXT SHOWN IN THE SCREEN
        let bg1 = SKSpriteNode(imageNamed: sprite)
        bg1.size = CGSize(width: (view.scene?.size.width)!, height: (view.scene?.size.height)!)
        bg1.position = CGPoint(x: (view.scene?.size.width)!, y: (view.scene?.size.height)! * 0.5)
        view.scene?.addChild(bg1)
        bg1.zPosition = zPosition
        
        if sprite == "smallStars" {
            bg.alpha = 0.4
            bg1.alpha = 0.4
        }
        
        let p1 = CGPoint(x: 0, y: (view.scene?.size.height)! * 0.5)
        let p2 = CGPoint(x: -(view.scene?.size.width)!, y: CGFloat((view.scene?.size.height)! * 0.5))
        let p3 = CGPoint(x: (view.scene?.size.width)!, y: CGFloat((view.scene?.size.height)! * 0.5))
        
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
        body.position = CGPoint(x: (((view.scene?.size.width)! * 0.5) + (width * 0.5)), y: 0)
        view.scene?.addChild(body)
        body.zPosition = zPosition
        
        body.alpha = 0.9
        
        let action = SKAction.move(to: CGPoint(x:-((view.scene?.size.width)! * 0.7),y:0), duration: duration)
        
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
        
        let action = SKAction.move(to: CGPoint(x:((view.scene?.size.width)! * 0.4),y:0), duration: duration)
        
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
