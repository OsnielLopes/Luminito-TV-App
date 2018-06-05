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
    
    var randomGen = RandomGenerator()
    var parallaxManager = ParallaxManager()
    
    override func didMove(to view: SKView) {
        
        guard let gameView = self.view else {return}
        
        let background = SKSpriteNode(imageNamed: "SpaceBG")
        background.position = (self.view?.center)!
        background.zPosition = -4
        self.view?.scene?.addChild(background)
        
        self.parallaxManager.startBackGroundParallax(view: gameView, sprite: "smallStars", duration: 500, zPosition: -3)
        self.parallaxManager.startBackGroundParallax(view: gameView, sprite: "mediumSmallStars", duration: 250, zPosition: -2)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
    }

    var deltaTimeTempForNebula = 0.0
    var lastTime: TimeInterval = 0.0
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        
        
        
        
        //This needs to be the last to avoid return before something
        let deltaTime = currentTime - lastTime
        if (deltaTime > deltaTimeTempForNebula) {
            print(deltaTime)
            guard let gameView = self.view else {return}
            if parallaxManager.isNebulaInScreen == false {
                
                self.deltaTimeTempForNebula = Double(self.randomGen.generateRandomNumber(min: 30, max: 60))
                
                self.parallaxManager.startCelestialBody(view: gameView, sprite: "nebula", width: ((gameView.scene?.size.width)! * 4), height: ((gameView.scene?.size.height)! * 3.4), duration: 20, zPosition: -1)
            }

        } else {
            return
        }
        lastTime = currentTime
    }
 
}


