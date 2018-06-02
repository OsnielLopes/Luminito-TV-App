//
//  GameScene.swift
//  Luminito
//
//  Created by Osniel Lopes Teixeira on 28/05/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var starsLayer1:[SKShapeNode] = []
    var starsLayer2:[SKShapeNode] = []
    var starsLayer3:[SKShapeNode] = []
    
    var randomGen = RandomGenerator()
    var parallaxManager = ParallaxManager()
    
    
    var storm = SKLightNode()
    var body2: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        guard let gameView = self.view else {return}
        
        let background = SKSpriteNode(imageNamed: "BackGround2")
        background.position = (self.view?.center)!
        background.zPosition = -4
        self.view?.scene?.addChild(background)
        
        self.parallaxManager.startBackGroundParallax(view: gameView, sprite: "smallStars", duration: 500, zPosition: -3)
        self.parallaxManager.startBackGroundParallax(view: gameView, sprite: "mediumSmallStars", duration: 250, zPosition: -2)
        
        
//        let body = SKSpriteNode(imageNamed: "Fundonovo")
//        body.size = CGSize(width: (self.view?.scene?.size.width)!, height: (self.view?.scene?.size.height)!)
//        body.position = CGPoint(x: 0, y: 0)
//        view.scene?.addChild(body)
//        body.zPosition = -1
//        body.lightingBitMask = 1
//
//        body2 = SKSpriteNode(imageNamed: "test")
//        body2?.size = CGSize(width: (self.view?.scene?.size.width)! * 1.3, height: (self.view?.scene?.size.height)! * 1.3)
//        body2?.position = CGPoint(x: 0, y: 0)
//        view.scene?.addChild(body2!)
//        body2?.zPosition = 0
//        body2?.lightingBitMask = 1
//
//        storm = SKLightNode()
//                    storm.categoryBitMask = 1
//                    storm.falloff = 1
//                    storm.ambientColor = SKColor.lightGray
//                    storm.isEnabled = true
//                    storm.position = CGPoint(x: 300, y: 100)
//
        
        
       
        
//        let a = SKAction.fadeOut(withDuration: 1)
//        let a2 = SKAction.fadeIn(withDuration: 1)
        
        
        
//        let actions:[SKAction] = [a,a2]
//        let acts = SKAction.sequence(actions)
//
//        storm.run(SKAction.repeatForever(acts))

        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
        //storm.run(SKAction.fadeAlpha(by: -0.9, duration: 1))
        
        
//        let vai = SKAction.run {
//            self.storm.isHidden = !self.storm.isHidden
//        }
//
//        let a = SKAction.wait(forDuration: TimeInterval(self.randomGen.generateRandomNumber(min: 6, max: 15)/10))
//
//        let act = SKAction.sequence([a,vai])
//        let m = SKAction.repeatForever(act)
//
//        self.storm.run(m)
        
        //body2?.addChild(storm)
        self.body2?.color = SKColor.black
        self.body2?.colorBlendFactor = 0.25
        let action = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.3)
        let actionQuick = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.1)
        //self.body2?.run(action)

        self.body2?.run(action, completion: {
            self.body2?.color = SKColor.black
            self.body2?.colorBlendFactor = 0.25
            self.body2?.run(actionQuick)
            self.body2?.color = SKColor.black
            self.body2?.colorBlendFactor = 0.25
            self.body2?.run(actionQuick)
        })
        
        //var animaiton = SKAction.sequence([])
      
        
        
        
//        var array:[SKLightNode] = []
//
//
//        var storm2 = SKLightNode()
//        storm2.categoryBitMask = 1
//        storm2.falloff = 1
//        storm2.ambientColor = SKColor.white
//        storm2.isEnabled = true
//        storm2.position = CGPoint(x: 300, y: 100)
//        self.body2?.addChild(storm2)
//        array.append(storm2)
        
//        let wait = SKAction.wait(forDuration: 0.3)
//
//        let light = SKAction.run {
//            var storm = SKLightNode()
//            storm.categoryBitMask = 1
//            storm.falloff = 1
//            storm.ambientColor = SKColor.lightGray
//            storm.isEnabled = true
//            storm.position = CGPoint(x: 300, y: 100)
//            self.body2?.addChild(storm)
//            array.append(storm)
//            self.aux += 1
//
//            self.body2?.run(wait)
//        }
//
//        let show = SKAction.run {
//            self.aux += 1
//            array[self.aux].isHidden = false
//        }
//
//        let remove = SKAction.run {
//            array[self.aux].isHidden = true
//            self.aux -= 1
//        }
//
//
//
//
//        let vamosla = SKAction.sequence([light,light,light,remove,wait,remove,wait,show,wait,remove,wait,remove])
//
//        self.body2?.run(vamosla)
        
    }
    
    var aux = -1
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    var deltaTime = 0.0
    var deltaTimeTemp = 0.0
    var deltaTimeTempForNebula = 4.0
    var lastTime: TimeInterval = 0.0
    
    override func update(_ currentTime: TimeInterval) {
        
        
        print(deltaTimeTemp)
        if (deltaTimeTemp >= deltaTimeTempForNebula) {
            
            guard let gameView = self.view else {return}
            
            if parallaxManager.isNebulaInScreen == false {
                self.parallaxManager.startCelestialBody(view: gameView, sprite: "test", width: ((gameView.scene?.size.width)! * 4), height: ((gameView.scene?.size.height)! * 3.4), duration: 60, zPosition: -1)
            }
                
            self.deltaTimeTempForNebula = Double(self.randomGen.generateRandomNumber(min: 60, max: 120))
            
            deltaTimeTemp = 0
        }
        
        deltaTime = 0.0
        deltaTime = currentTime - lastTime
        lastTime = currentTime
        deltaTimeTemp += deltaTime
        
        
    }
    
    
}


