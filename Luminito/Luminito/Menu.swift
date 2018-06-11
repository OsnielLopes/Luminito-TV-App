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
    
    var gameStarted = false
    
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
        let moveLuminitoLabelToCenter = SKAction.move(to: CGPoint(x: gameScene.size.width/2, y: gameScene.size.height * 0.75), duration: 1.5)
        gameScene.childNode(withName: "Luminito Label")?.run(moveLuminitoLabelToCenter)
        
        let moveForeverLabelToCenter = SKAction.move(to: CGPoint(x: gameScene.size.width/2, y: gameScene.size.height * 0.60), duration: 1.5)
        gameScene.childNode(withName: "Forever Label")?.run(moveForeverLabelToCenter)
        
        let movePlayButtonToCenter = SKAction.move(to: CGPoint(x: gameScene.size.width/2, y: gameScene.size.height * 0.40), duration: 1.5)
        gameScene.childNode(withName: "Play Button")?.run(movePlayButtonToCenter)
        gameScene.childNode(withName: "Play Button")?.isUserInteractionEnabled = true
    }
    
    //Animação para levar o menu para a esquerda até ficar fora da scene
    func moveMenuToLeftSide(gameScene: SKScene){
        let moveLuminitoToLeft = SKAction.move(to: CGPoint(x: -gameScene.size.width, y: gameScene.size.height * 0.75), duration: 1.5)
        gameScene.childNode(withName: "Luminito Label")?.run(moveLuminitoToLeft)
        
        let moveForeverLabelToLeft = SKAction.move(to: CGPoint(x: -gameScene.size.width, y: gameScene.size.height * 0.60), duration: 1.5)
        gameScene.childNode(withName: "Forever Label")?.run(moveForeverLabelToLeft)
        
        let movePlayButtonToLeft = SKAction.move(to: CGPoint(x: -gameScene.size.width, y: gameScene.size.height * 0.40), duration: 1.5)
        gameScene.childNode(withName: "Play Button")?.run(movePlayButtonToLeft)
        gameScene.childNode(withName: "Play Button")?.isUserInteractionEnabled = false
    }

    //Animação do Luminito entrando na scene
    func playTapped(gameScene: SKScene){
        self.moveMenuToLeftSide(gameScene: gameScene)
        let moveLuminitoToScene = SKAction.move(to: CGPoint(x: gameScene.size.width * 0.1, y: gameScene.size.height * 0.50), duration: 1.0)
        gameScene.childNode(withName: "Luminito")?.run(moveLuminitoToScene)
        gameScene.childNode(withName: "Luminito")?.isUserInteractionEnabled = true
        
        self.gameStarted = true
    }
    
    // Animação do luminito saindo da scene e o menu voltando ao meio
    func menuTapped(gameScene: SKScene){
        let moveLuminitoToLeft = SKAction.move(to: CGPoint(x: -gameScene.size.width, y: gameScene.size.height * 0.50), duration: 1.0)
        gameScene.childNode(withName: "Luminito")?.run(moveLuminitoToLeft)
        gameScene.childNode(withName: "Luminito")?.isUserInteractionEnabled = false
        self.moveMenuToCenter(gameScene: gameScene)
    }
    
}
