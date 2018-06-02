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
    case velocityBoost, meteorRepellent, meteorDestroyer, magnet, oneMoreLife, intangibility, none
}

class GameViewController: UIViewController, SKSceneDelegate, SKPhysicsContactDelegate {
    
    //MARK: - Luminito
    var luminito: SKSpriteNode?
    
    //MARK: - Variables
    var scene: SKScene!
    var colectible: Colectible = .intangibility
    let luminitoCategory: UInt32 = 0x1 << 0
    let meteorCategory: UInt32 = 0x1 << 1
    let intangibleluminitoCategory: UInt32 = 0x1 << 2
    
    var deltaTime = 0.0
    var deltaTimeTemp = 0.0
    var lastTime: TimeInterval = 0.0
    
    //MARK: - Managers
    var powerUpGenerator: PowerUpGenerator?
    
    //MARK: - Arrays
    var meteors:[SKMeteorNode] = []
    var backgrounds:[SKSpriteNode] = []
    
    lazy var distanceLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Avenir")
        label.fontSize = 36
        label.fontColor = UIColor.yellow
        label.horizontalAlignmentMode = .right
        label.verticalAlignmentMode = .bottom
        
        //Distance between pluto and the Sun: 6 billion km
        //Light Speed in kilometers: 300.000 km/s, each second decrements 300.000 from the label
        label.text = "6000000000 km"
        
        return label
    }()
    
    var distance: Int = 6000000000 {
        didSet {
            self.distanceLabel.text = "\(distance) km"
        }
    }
    
    //MARK: - View Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.powerUpGenerator = PowerUpGenerator(gameViewController: self)
        
        if let view = self.view as! SKView? {
            
            scene = SKScene(size: view.frame.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.delegate = self
            scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            scene.physicsWorld.contactDelegate = self
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        
            //adds the luminito node
            self.luminito = SKSpriteNode(imageNamed: "Character Wow")
            let position = CGPoint(x: self.scene.frame.width*0.1, y: self.scene.frame.height*0.5)
            luminito?.position = position
            let luminitoPhysicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Character Wow"), size: (luminito?.size)!)
            luminitoPhysicsBody.categoryBitMask = luminitoCategory
            luminitoPhysicsBody.collisionBitMask = meteorCategory
            luminitoPhysicsBody.isDynamic = false
            luminito?.physicsBody = luminitoPhysicsBody
            self.scene.addChild(luminito!)
            
            addMeteors()
            
            //add HUD
            self.distanceLabel.position = CGPoint(x: self.scene.frame.width * 0.15, y: self.scene.frame.height * 0.95)
            self.scene.addChild(self.distanceLabel)
            
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

        if (deltaTimeTemp >= 1.0) {
            //A second passed, 300.000 km traveled
            //self.distance -= 300000
            deltaTimeTemp = 0
        }

        //Update calls it 60 times per second, so in one second is 5000 * 60 = 300.000 km (1s c)
        if self.colectible == .velocityBoost {
            distance -= 15000
        } else {
            distance -= 5000
        }
        
        deltaTime = 0.0
        deltaTime = currentTime - lastTime
        lastTime = currentTime
        deltaTimeTemp += deltaTime
        
        scene.enumerateChildNodes(withName: "meteor") { (node, stop) in
            guard let meteor = node as? SKMeteorNode else {
                print("Impossible to convert the node to a SKMeteorNode")
                return
            }
            
            //If meteor is off the Scene
            if !((self.scene.view?.frame.contains(meteor.position))!) {
                
                //Sets meteor new position
                let yPos = arc4random_uniform(UInt32(self.scene.frame.height))
                meteor.position = CGPoint(x: self.scene.frame.width, y: CGFloat(yPos))

            }
            
            if self.colectible == .none {
                meteor.physicsBody?.velocity = CGVector(dx: meteor.initialVelocity, dy: 0)
            }
        }
    }
    
    //MARK: - ContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    //MARK: - Gesture Recognition
    
    @objc func didTap(){
        
        self.colectible = .intangibility
        
        switch self.colectible {
        case .intangibility:
            
            self.powerUpGenerator?.generateIntangibilityPowerUp()
            print("Intangibility Engaged")
        case .velocityBoost:
            
            self.powerUpGenerator?.generateVelocityBoostPowerUp()
            print("Velocity Engaged")
            
        case .meteorRepellent:
            print("not allowed yet")
        case .meteorDestroyer:
            print("not allowed yet")
        case .magnet:
            print("not allowed yet")
        case .oneMoreLife:
            print("not allowed yet")
        case .none:
            print("powerUps disabled")
        }
        
        self.scene.enumerateChildNodes(withName: "meteor") { (node, end) in
            guard let meteor = node as? SKSpriteNode else {
                return
            }
        }
        
    }
    
    //MARK: - Auxiliar Functions
    
    private func addMeteors() {
        for _ in 0..<10{
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
        self.meteors.append(meteor)
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

