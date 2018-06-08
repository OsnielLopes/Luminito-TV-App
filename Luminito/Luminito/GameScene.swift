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
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var luminitoLabel = SKSpriteNode(imageNamed: "Titulo_inicial")
    var foreveLabel = SKSpriteNode(imageNamed: "Forever")
    var playButton = SKSpriteNode(imageNamed: "Menu Play Button")
    var storeButton = SKSpriteNode(imageNamed: "Store Button")
    var luminito = SKSpriteNode(imageNamed: "Character Wow")
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        luminitoLabel.name = "Luminito Label"
        luminitoLabel.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.frame.size.height)! * 0.30)
        luminitoLabel.size = CGSize(width: 380.0, height: 115.0)
        self.addChild(luminitoLabel)
        
        foreveLabel.name = "Forever Label"
        foreveLabel.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.frame.size.height)! * 0.12)
        foreveLabel.size = CGSize(width: 250.0, height: 100.0)
        self.addChild(foreveLabel)
        
        playButton.name = "Play Button"
        playButton.focusBehavior = .focusable
        playButton.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.frame.size.height)! * -0.10)
        playButton.size = CGSize(width: 140.0, height: 65.0)
        self.addChild(playButton)
        
        storeButton.name = "Store Button"
        storeButton.focusBehavior = .focusable
        storeButton.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.frame.size.height)! * -0.25)
        storeButton.size = CGSize(width: 140.0, height: 65.0)
        self.addChild(storeButton)
        
        luminito.name = "Luminito"
        luminito.position = CGPoint(x: -(scene?.size.width)!/1.4, y: 0.0)
        self.addChild(luminito)
        
        let menu = Menu.init(gameScene: self)
        menu.moveMenuToCenter(gameScene: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            menu.moveMenuToLeftSide(gameScene: self)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                menu.playTapped(gameScene: self)
//            })
        })
    
        addSelectRecognizer()
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
    
    func addSelectRecognizer(){
        let selectRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.buttonSelected(sender:)))
        selectRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
        self.view?.addGestureRecognizer(selectRecognizer)
    }
    
    @objc func buttonSelected(sender: AnyObject){
        if(playButton.isFocused){
            print("Play selected")
        }else{
            print("Store selected")
        }
    }
    
    
    
    
}
