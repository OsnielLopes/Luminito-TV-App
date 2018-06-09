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
    
    init() {
        super.init(texture: SKTexture(imageNamed: "Ateroide Grande"), color: UIColor.clear, size: CGSize(width: 0.0, height: 0.0))
    }
    
    init(gameScene: SKScene) {
        super.init(texture: SKTexture(imageNamed: "Ateroide Grande"), color: UIColor.clear, size: CGSize(width: 0.0, height: 0.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Animação para trazer todo o menu para o centro da scene
    func moveMenuToCenter(gameScene: SKScene){
        let moveLuminitoToCenter = SKAction.move(to: CGPoint(x: 0.0, y: gameScene.size.height * 0.30), duration: 1.5)
        gameScene.childNode(withName: "Luminito Label")?.run(moveLuminitoToCenter)
        
        let moveForeverLabelToCenter = SKAction.move(to: CGPoint(x: 0.0, y: gameScene.size.height * 0.12), duration: 1.5)
        gameScene.childNode(withName: "Forever Label")?.run(moveForeverLabelToCenter)

        let movePlayButtonToCenter = SKAction.move(to: CGPoint(x: 0.0, y: gameScene.size.height * -0.10), duration: 1.5)
        gameScene.childNode(withName: "Play Button")?.run(movePlayButtonToCenter)
        gameScene.childNode(withName: "Play Button")?.isUserInteractionEnabled = true
        
        let moveStoreButtonToCenter = SKAction.move(to: CGPoint(x: 0.0, y: gameScene.size.height * -0.25), duration: 1.5)
        gameScene.childNode(withName: "Store Button")?.run(moveStoreButtonToCenter)
        gameScene.childNode(withName: "Store Button")?.isUserInteractionEnabled = true
    }
    
    //Animação para levar o menu para a esquerda até ficar fora da scene
    func moveMenuToLeftSide(gameScene: SKScene){
        let moveLuminitoToCenter = SKAction.move(to: CGPoint(x: -gameScene.size.width, y: gameScene.size.height * 0.30), duration: 1.5)
        gameScene.childNode(withName: "Luminito Label")?.run(moveLuminitoToCenter)

        let moveForeverLabelToCenter = SKAction.move(to: CGPoint(x: -gameScene.size.width, y: gameScene.size.height * 0.12), duration: 1.5)
        gameScene.childNode(withName: "Forever Label")?.run(moveForeverLabelToCenter)

        let movePlayButtonToCenter = SKAction.move(to: CGPoint(x: -gameScene.size.width, y: gameScene.size.height * -0.10), duration: 1.5)
        gameScene.childNode(withName: "Play Button")?.run(movePlayButtonToCenter)
        gameScene.childNode(withName: "Play Button")?.isUserInteractionEnabled = false

        let moveStoreButtonToCenter = SKAction.move(to: CGPoint(x: -gameScene.size.width, y: gameScene.size.height * -0.25), duration: 1.5)
        gameScene.childNode(withName: "Store Button")?.run(moveStoreButtonToCenter)
        gameScene.childNode(withName: "Store Button")?.isUserInteractionEnabled = false
    }
    
    //Animação do Luminito entrando na scene
    func playTapped(gameScene: SKScene){
        self.moveMenuToLeftSide(gameScene: gameScene)
        let moveLuminitoToScene = SKAction.move(to: CGPoint(x: -(gameScene.size.width)/2.3, y: 0.0), duration: 1.0)
        gameScene.childNode(withName: "Luminito")?.run(moveLuminitoToScene)
        gameScene.childNode(withName: "Luminito")?.isUserInteractionEnabled = true
    }
    
    func menuTapped(gameScene: SKScene){
        self.moveMenuToCenter(gameScene: gameScene)
        let moveLuminitoToLeft = SKAction.move(to: CGPoint(x: -(gameScene.size.width)/1.4, y: 0.0), duration: 1.0)
        gameScene.childNode(withName: "Luminito")?.run(moveLuminitoToLeft)
        gameScene.childNode(withName: "Luminito")?.isUserInteractionEnabled = false
    }
    
}
