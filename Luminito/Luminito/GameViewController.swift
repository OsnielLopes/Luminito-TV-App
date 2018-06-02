//
//  GameViewController.swift
//  Luminito
//
//  Created by Osniel Lopes Teixeira on 28/05/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

enum Colectible {
    case velocityBoost, meteorRepellent, meteorDestroyer, magnet, oneMoreLife, intagibility
}

class GameViewController: UIViewController, SKSceneDelegate {
    
    //MARK: - Variables
    var scene: SKScene!
    var colectible: Colectible = .intagibility
    let luminitoCategory: UInt32 = 0x1 << 0
    let meteorCategory: UInt32 = 0x1 << 1
    
    //MARK: - View Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            scene = SKScene(size: view.frame.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.delegate = self
            scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            //adds the luminito node
            let luminito = SKSpriteNode(imageNamed: "Character Wow")
            let position = CGPoint(x: self.scene.frame.width*0.1, y: self.scene.frame.height*0.5)
            luminito.position = position
            let luminitoPhysicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Character Wow"), size: luminito.size)
            luminitoPhysicsBody.categoryBitMask = luminitoCategory
            luminitoPhysicsBody.collisionBitMask = meteorCategory
            luminitoPhysicsBody.isDynamic = false
            luminito.physicsBody = luminitoPhysicsBody
            self.scene.addChild(luminito)
            
            addMeteors()
            
            //add the tap recognizer
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
            view.addGestureRecognizer(tapRecognizer)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    //MARK: - SKSceneDelegate
    
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        scene.enumerateChildNodes(withName: "meteor") { (node, stop) in
            guard let meteor = node as? SKMeteorNode else {
                print("Impossible to convert the node to a SKMeteorNode")
                return
            }
            if !((self.scene.view?.frame.contains(meteor.position))!) {
                let yPos = arc4random_uniform(UInt32(self.scene.frame.height))
                meteor.position = CGPoint(x: self.scene.frame.width, y: CGFloat(yPos))
                meteor.physicsBody?.velocity = CGVector(dx: meteor.initialVelocity, dy: 0)
                
            }
        }
    }
    
    //MARK: - Gesture Recognition
    
    @objc func didTap(){
        
        switch self.colectible {
        case .intagibility:
            print("not allowed yet")
        case .velocityBoost:
            print("not allowed yet")
        case .meteorRepellent:
            print("not allowed yet")
        case .meteorDestroyer:
            print("not allowed yet")
        case .magnet:
            print("not allowed yet")
        case .oneMoreLife:
            print("not allowed yet")
        }
        
        self.scene.enumerateChildNodes(withName: "meteor") { (node, end) in
            guard let meteor = node as? SKSpriteNode else {
                return
            }
        }
        
    }
    
    //MARK: - Auxiliar Functions
    
    private func addMeteors() {
        for _ in 0..<40{
            addMeteor()
        }
    }
    
    func addMeteor(){
        let xVelocity = -(Int(arc4random_uniform(200))+200)
        let meteor = SKMeteorNode(imageNamed: "Asteroide Pequeno", initialVelocity: xVelocity)
        meteor.name = "meteor"
        let yPos = arc4random_uniform(UInt32(self.scene.frame.height))
        let meteorPosition = CGPoint(x: self.scene.frame.width, y: CGFloat(yPos))
        meteor.position = meteorPosition
        let meteorPhysicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Asteroide Pequeno"), size: meteor.size)
        meteorPhysicsBody.categoryBitMask = meteorCategory
        meteorPhysicsBody.collisionBitMask = luminitoCategory | meteorCategory
        meteorPhysicsBody.isDynamic = true
        meteorPhysicsBody.restitution = 1
        meteorPhysicsBody.linearDamping = 0
        meteor.physicsBody = meteorPhysicsBody
        self.scene.addChild(meteor)

        //adds the movement
        meteor.physicsBody?.velocity = CGVector(dx: xVelocity, dy: 0)
    
//        let timeInterval = TimeInterval(arc4random_uniform(10)+5)
//        let animation = SKAction.moveTo(x: 0, duration: timeInterval)
//        meteor.run(animation) {
//            //after the completion of the animation, the node is removed from the screen and a new node is then added
//            meteor.removeFromParent()
//            self.addMeteor()
//        }
    }
}

