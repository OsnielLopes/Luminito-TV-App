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
    var luminito = SKSpriteNode(texture: SKTexture(imageNamed: "Character Idle"))
    var meteorArray = [Meteor]()
    var playing = true
    
    override func didMove(to view: SKView) {
        
        addTapGestureRecognizer()
        
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
        
        luminito.position = CGPoint(x: -(scene?.size.width)!/2.3, y: 0.0)
        luminito.size = CGSize(width: 100.0, height: 100.0)
        let range = SKRange(lowerLimit: (((scene?.frame.size.height)!/2) * -1) + 20, upperLimit: ((scene?.frame.size.height)!/2) - 20)
        let topAndBottomLocker = SKConstraint.positionY(range)
        
        luminito.constraints = [ topAndBottomLocker ]
        luminito.isUserInteractionEnabled = true
        self.addChild(luminito)

        let meteor = Meteor.init(gameScene: self)
        meteor.createRandomMeteor()
        self.view?.scene?.addChild(meteor)
        meteor.moveMeteor()
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            if(pos.y < (scene?.view?.frame.size.height)!/2 - 30.0 && pos.y > ((scene?.view?.frame.size.height)!/2 * -1) + 30.0){
                if (pos.y == n.position.y){
                    
                }
                else if (pos.y > n.position.y){
                    luminito.position.y += 10
                }else{
                    luminito.position.y -= 10
                }
                self.spinnyNode?.position.y = pos.y
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func addTapGestureRecognizer() {
        let playPauseButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.playPauseTapped(sender:)))
        playPauseButtonRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue)]
        self.view?.addGestureRecognizer(playPauseButtonRecognizer)
    }
    
    @objc func playPauseTapped(sender:AnyObject) {
        if(playing == false){
            play()
        }else{
            pause()
        }
    }
    
    func play(){
        print("play")
        self.isPaused = false
        playing = true
    }
    
    func pause(){
        print("pause")
        self.isPaused = true
        playing = false
    }
    
}
