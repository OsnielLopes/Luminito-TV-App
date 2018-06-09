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
    
    let menu = Menu()
    var luminitoLabel = SKSpriteNode(imageNamed: "Titulo_inicial")
    var foreveLabel = SKSpriteNode(imageNamed: "Forever")
    var playButton = MenuButton(imageNamed: "Menu Play Button")
    var storeButton = MenuButton(imageNamed: "Store Button")
    var luminito = SKSpriteNode(imageNamed: "Character Wow")
    var buttons = [MenuButton]()
    var playing = false
    
    override func didMove(to view: SKView) {
        
        // Configurações iniciais
        luminitoLabel.name = "Luminito Label"
        luminitoLabel.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.frame.size.height)! * 0.30)
        luminitoLabel.size = CGSize(width: 380.0, height: 115.0)
        self.addChild(luminitoLabel)
        
        foreveLabel.name = "Forever Label"
        foreveLabel.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.frame.size.height)! * 0.12)
        foreveLabel.size = CGSize(width: 250.0, height: 100.0)
        self.addChild(foreveLabel)
        
        playButton.name = "Play Button"
        playButton.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.frame.size.height)! * -0.10)
        playButton.size = CGSize(width: 140.0, height: 65.0)
        playButton.isUserInteractionEnabled = true
        buttons.append(playButton)
        self.addChild(playButton)
        
        storeButton.name = "Store Button"
        storeButton.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.frame.size.height)! * -0.25)
        storeButton.size = CGSize(width: 140.0, height: 65.0)
        storeButton.isUserInteractionEnabled = true
        buttons.append(storeButton)
        self.addChild(storeButton)
        
        luminito.name = "Luminito"
        luminito.position = CGPoint(x: -(scene?.size.width)!/1.4, y: 0.0)
        self.addChild(luminito)
        
        let menu = Menu(gameScene: self)
        menu.moveMenuToCenter(gameScene: self)
        
        addSelectRecognizer()
        addMenuRecognizer()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    // Adiciona o recognizer de quando é dado um click do remote
    func addSelectRecognizer(){
        let selectRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.buttonSelected(sender:)))
        selectRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        self.view?.addGestureRecognizer(selectRecognizer)
    }
    
    // Adiciona o recognizer do botão menu do remote
    func addMenuRecognizer(){
        let menuRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.menuPressed(sender:)))
        menuRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.menu.rawValue)]
        self.view?.addGestureRecognizer(menuRecognizer)
    }
    
    // Executa quando é dado um click no remote
    @objc func buttonSelected(sender: AnyObject){
        if let focussedItem = UIScreen.main.focusedItem as? MenuButton {
            if(focussedItem.name == "Play Button"){
                print("Play selected")
                menu.playTapped(gameScene: self)
                playing = true
            }else{
                print("Store selected")
            }
        }
        
    }
    
    // Executa quando o botão menu do remote é pressionado
    @objc func menuPressed(sender: AnyObject){
        if(playing == true){
            menu.menuTapped(gameScene: self)
        }else{
            //TODO: Go back to AppleTV menu screen
        }
    }

    // Troca o botão focado
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let prevItem = context.previouslyFocusedItem
        let nextItem = context.nextFocusedItem

        if let prevButton = prevItem as? MenuButton {
            prevButton.buttonDidLoseFocus()
        }
        if let nextButton = nextItem as? MenuButton {
            nextButton.buttonDidGetFocus()
        }
    }

}
