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
    
    //MARK: - Initializer
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }
    
    //MARK: - Power Up generators functions
    func generateVelocityBoostPowerUp() {
        
        let meteors = self.gameViewController?.meteors
        for meteor in meteors! {
            meteor.physicsBody?.velocity = CGVector(dx: meteor.initialVelocity * 3, dy: 0)
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(stop)), userInfo: nil, repeats: false)
    }
    
    //MARK: - Power Up time stop
    @objc func stop() {
        self.gameViewController?.colectible = .none
    }
    
}
