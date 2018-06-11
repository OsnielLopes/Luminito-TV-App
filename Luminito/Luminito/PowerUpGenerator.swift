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
    var powerUps: [Colectible] = [.intangibility,.intangibility,.velocityBoost,.velocityBoost,.velocityBoost,.meteorDestroyer,.magnet,.magnet]
    var powerUpNames:[String] = ["ghost","ghost","boostVelocity","boostVelocity","boostVelocity","bomb","magnet","magnet"]
    var randonGen = RandomGenerator()
    var isMagnetActive = false
    
    //MARK: - Initializer
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }
    
    //MARK: - Power Up generator
    
    func generatePowerUp() -> (colectible: Colectible, name: String) {
        let ran = self.randonGen.generateRandomNumber(min: 2, max: self.powerUps.count - 3)
        let colectible = self.powerUps[ran]
        let name = self.powerUpNames[ran]
        
        let tuple = (colectible: colectible,name: name)
        return tuple
    }
    
    //MARK: - Power Up activate functions
    func activateVelocityBoostPowerUp() {
        
        self.gameViewController?.luminito.physicsBody?.categoryBitMask = (self.gameViewController?.intangibleLuminitoCategory)!
        
        let meteors = self.gameViewController?.meteors
        for meteor in meteors! {
            meteor.physicsBody?.velocity = CGVector(dx: meteor.initialVelocity * 3, dy: 0)
        }
        
        self.gameViewController?.velocity = (self.gameViewController?.velocity)! * 3
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(stop)), userInfo: nil, repeats: false)
    }
    
    func activateIntangibilityPowerUp() {
        self.gameViewController?.luminito.physicsBody?.categoryBitMask = (self.gameViewController?.intangibleLuminitoCategory)!
        self.gameViewController?.luminito.run(SKAction.fadeAlpha(to: 0.5, duration: 3))
        self.timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: (#selector(stop)), userInfo: nil, repeats: false)
    }
    
    func activateMeteorDestroyerPowerUp() {
        var meteors = self.gameViewController?.meteors
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let seq = SKAction.sequence([fadeOut,fadeIn])
        let action = SKAction.repeat(seq, count: 4)
        
        for meteor in meteors! {
            meteor.run(action) {
                meteor.removeFromParent()
            }
        }
        
        meteors = []
        
        self.gameViewController?.luminito.physicsBody?.categoryBitMask = (self.gameViewController?.intangibleLuminitoCategory)!
        
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: (#selector(stop)), userInfo: nil, repeats: false)
    }
    
    func activateMagnetPowerUp() {
        self.isMagnetActive = true
        self.timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: (#selector(stop)), userInfo: nil, repeats: false)
    }
    
    func activateOneMoreLifePowerUp() {
        
    }
    
    
    
    //MARK: - Power Up time stop
    @objc func stop() {
        
        if ((self.gameViewController?.colectible == .velocityBoost)) {
            
            let meteors = self.gameViewController?.meteors
            for meteor in meteors! {
                meteor.physicsBody?.velocity = CGVector(dx: meteor.initialVelocity / 3, dy: 0)
            }
            
            self.gameViewController?.velocity = (self.gameViewController?.velocity)! / 3
        } else if self.gameViewController?.colectible == .meteorDestroyer{
            self.gameViewController?.addMeteors(qtde: (self.gameViewController?.qtdeMeteors)!)
        }
        
        self.isMagnetActive = false
        self.gameViewController?.colectible = .none
        self.gameViewController?.currentPowerUp?.texture = nil
        
        self.gameViewController?.luminito.run(SKAction.fadeIn(withDuration: 3), completion: {
            self.gameViewController?.luminito.physicsBody?.categoryBitMask = (self.gameViewController?.luminitoCategory)!
        })
    }
    
}
