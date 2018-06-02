//
//  SKMeteorNode.swift
//  Luminito
//
//  Created by Osniel Lopes Teixeira on 30/05/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import SpriteKit

class SKMeteorNode: SKSpriteNode {
    
    //MARK: - Variables
    var initialVelocity: Int
    
    init(imageNamed: String, initialVelocity: Int){
        self.initialVelocity = initialVelocity
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
