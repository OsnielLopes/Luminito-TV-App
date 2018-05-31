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
    
    override func didMove(to view: SKView) {
        
        guard let gameView = self.view else {return}
        
        self.parallaxManager.startBackGroundParallax(view: gameView, sprite: "smallStars", duration: 500, zPosition: -3)
        self.parallaxManager.startBackGroundParallax(view: gameView, sprite: "mediumSmallStars", duration: 250, zPosition: -2)
        
        
        self.view?.scene?.backgroundColor = UIColor.black
        
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
        
        
    }
    
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
    var deltaTimeTempForNebula = 0.0
    var lastTime: TimeInterval = 0.0
    
    override func update(_ currentTime: TimeInterval) {
        
        if currentTime < 250000 {
            deltaTime = currentTime - lastTime
            lastTime = currentTime
            deltaTimeTemp += deltaTime
        }
        
        print(deltaTimeTemp)
        if (deltaTimeTemp >= deltaTimeTempForNebula) {
            
            guard let gameView = self.view else {return}
            self.parallaxManager.startCelestialBody(view: gameView, sprite: "test", width: ((gameView.scene?.size.width)! * 4), height: ((gameView.scene?.size.height)! * 3.4), duration: 60, zPosition: -1)
                
            self.deltaTimeTempForNebula = Double(self.randomGen.generateRandomNumber(min: 10, max: 10))
            
            deltaTimeTemp = 0
        }
        
        
    }
    
    
}


