//
//  Meteor.swift
//  Luminito
//
//  Created by Vinícius Cano Santos on 29/05/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import Foundation
import SpriteKit

public class Meteor: SKSpriteNode {
    
    var id: Int?
    var meteorspeed: Float?
    var width: CGFloat
    var height: CGFloat
    
    init(gameScene: SKScene) {
        self.id = -1
        self.meteorspeed = 20
        self.width = gameScene.frame.width
        self.height = gameScene.frame.height
        print(width)
        print(height)
        super.init(texture: SKTexture(imageNamed: "Asteroide Grande"), color: UIColor.red, size: CGSize(width: 0, height: 0))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createRandomMeteor() {
        
        var type = Int(arc4random_uniform(2))
        let randomNumber2 = Float(arc4random()) / Float(UInt32.max)
        
        if(type == 1){
            self.texture = SKTexture(imageNamed: "Asteroide Grande")
            self.size = CGSize(width: 50, height: 50)
            self.position = CGPoint(x: width/1.9, y: height/2 - height * CGFloat(randomNumber2))
        }else{
            self.texture = SKTexture(imageNamed: "Asteroide Pequeno")
            self.size = CGSize(width: 30, height: 30)
            self.position = CGPoint(x: width/1.9, y: height/2 - height * CGFloat(randomNumber2))
        }
        
    }
    
    func moveMeteor(){
        
    }
    
    
}
