//
//  PowerUpGenerator.swift
//  Luminito
//
//  Created by Pedro Del Rio Ortiz on 02/06/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import Foundation
import SpriteKit

class PowerUpGenerator {
    
    //MARK: - Variables
    var timer = Timer()
    let gameViewController: GameViewController?
    var powerUps: [Colectible] = [.intangibility,.intangibility,.velocityBoost,.velocityBoost,.velocityBoost]
    var powerUpNames:[String] = ["ghost","ghost","boostVelocity","boostVelocity","boostVelocity"]
    var randonGen = RandomGenerator()
    
    //MARK: - Initializer
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }
    
    //MARK: - Power Up generator
    
    func generatePowerUp() -> (colectible: Colectible, name: String) {
        let ran = self.randonGen.generateRandomNumber(min: 0, max: self.powerUps.count - 1)
        let colectible = self.powerUps[ran]
        let name = self.powerUpNames[ran]
        
        let tuple = (colectible: colectible,name: name)
        return tuple
    }
    
    //MARK: - Power Up activate functions
    func activateVelocityBoostPowerUp() {
        
        let meteors = self.gameViewController?.meteors
        for meteor in meteors! {
            meteor.physicsBody?.velocity = CGVector(dx: meteor.initialVelocity * 3, dy: 0)
        }
        
        self.gameViewController?.velocity = (self.gameViewController?.velocity)! * 3
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(stop)), userInfo: nil, repeats: false)
    }
    
    func activateIntangibilityPowerUp() {
        self.gameViewController?.luminito?.physicsBody?.categoryBitMask = (self.gameViewController?.intangibleLuminitoCategory)!
        self.gameViewController?.luminito?.run(SKAction.fadeAlpha(to: 0.5, duration: 3))
        self.timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: (#selector(stop)), userInfo: nil, repeats: false)
    }
    
    //MARK: - Power Up time stop
    @objc func stop() {
        
        if ((self.gameViewController?.colectible = .velocityBoost) != nil) {
            self.gameViewController?.velocity = (self.gameViewController?.velocity)! / 3
        }
        
        self.gameViewController?.colectible = .none
        
        self.gameViewController?.luminito?.run(SKAction.fadeIn(withDuration: 3), completion: {
            self.gameViewController?.luminito?.physicsBody?.categoryBitMask = (self.gameViewController?.luminitoCategory)!
        })
    }
    
}
