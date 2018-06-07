//
//  MenuActions.swift
//  Luminito
//
//  Created by Vinícius Cano Santos on 07/06/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit
import SpriteKit

class Menu: SKSpriteNode {

    init(gameScene: SKScene) {
        super.init(texture: SKTexture(imageNamed: "Ateroide Grande"), color: UIColor.clear, size: CGSize(width: 0.0, height: 0.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveMenuToCenter(gameScene: SKScene){
        let moveLuminitoToCenter = SKAction.move(to: CGPoint(x: 0.0, y: 150.0), duration: 1.5)
        gameScene.childNode(withName: "Luminito Label")?.run(moveLuminitoToCenter)
        
        let moveForeverLabelToCenter = SKAction.move(to: CGPoint(x: 0.0, y: 50.0), duration: 1.5)
        gameScene.childNode(withName: "Forever Label")?.run(moveForeverLabelToCenter)

        let movePlayButtonToCenter = SKAction.move(to: CGPoint(x: 0.0, y: -50.0), duration: 1.5)
        gameScene.childNode(withName: "Play Button")?.run(movePlayButtonToCenter)

        let moveStoreButtonToCenter = SKAction.move(to: CGPoint(x: 0.0, y: -120.0), duration: 1.5)
        gameScene.childNode(withName: "Store Button")?.run(moveStoreButtonToCenter)
    }
    
    func moveMenuToLeftSide(gameScene: SKScene){
        let moveLuminitoToCenter = SKAction.move(to: CGPoint(x: -1000.0, y: 150.0), duration: 1.5)
        gameScene.childNode(withName: "Luminito Label")?.run(moveLuminitoToCenter)

        let moveForeverLabelToCenter = SKAction.move(to: CGPoint(x: -1000.0, y: 50.0), duration: 1.5)
        gameScene.childNode(withName: "Forever Label")?.run(moveForeverLabelToCenter)

        let movePlayButtonToCenter = SKAction.move(to: CGPoint(x: -1000.0, y: -50.0), duration: 1.5)
        gameScene.childNode(withName: "Play Button")?.run(movePlayButtonToCenter)

        let moveStoreButtonToCenter = SKAction.move(to: CGPoint(x: -1000.0, y: -120.0), duration: 1.5)
        gameScene.childNode(withName: "Store Button")?.run(moveStoreButtonToCenter)
    }
    
}
