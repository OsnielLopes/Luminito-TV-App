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
    let intangibleLuminitoCategory: UInt32 = 0x1 << 2
    let electronCategory: UInt32 = 0x1 << 3
    var gameover = false
    var playing = true
    var luminitoInteraction = true
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
    
    lazy var energyLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Avenir")
        label.fontSize = 36
        label.fontColor = UIColor.yellow
        label.horizontalAlignmentMode = .right
        label.verticalAlignmentMode = .bottom

        label.text = "0 N"
        
        return label
    }()
    
    var energy: Int = 0 {
        didSet {
            self.energyLabel.text = "\(energy) N"
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
            self.addTapGestureRecognizer()
            
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
            addElectron()
            
            //add HUD
            self.distanceLabel.position = CGPoint(x: self.scene.frame.width * 0.15, y: self.scene.frame.height * 0.95)
            self.scene.addChild(self.distanceLabel)
            self.energyLabel.position = CGPoint(x: (self.scene.frame.width * 0.85) - self.energyLabel.frame.width, y: self.scene.frame.height * 0.95)
            self.scene.addChild(self.energyLabel)
            
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
        
        if self.gameover == false {
            if (deltaTimeTemp >= 1.0) {
                //A second passed, 300.000 km traveled
                //self.distance -= 300000
                deltaTimeTemp = 0
            }
            
            //Update calls it 60 times per second, so in one second is 5000 * 60 = 300.000  km (1s c)
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
            
            scene.enumerateChildNodes(withName: "electron") { (electron, stop) in
                //If the electron is off the scene
                if !((self.scene.view?.frame.contains(electron.position))!) && electron.position.x < self.scene.frame.width {
                    //Sets electron new position
                    let yPos = arc4random_uniform(UInt32(self.scene.frame.height))
                    electron.position = CGPoint(x: self.scene.frame.width + 10, y: CGFloat(yPos))
                }
            }
        }
    }
    
    //MARK: - ContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Luminito
        let whoTouch = contact.bodyA
        
        //Meteor, PowerUps, Coins
        let wasTouched = contact.bodyB
        
        if wasTouched.categoryBitMask == meteorCategory {
            //Something touched meteor
            
            switch whoTouch.categoryBitMask {
            case luminitoCategory:
                //Luminito touched meteor and dies tragically
                
                self.gameover = true
                
                for meteor in self.meteors {
                    meteor.physicsBody = nil
                }
                
                whoTouch.categoryBitMask = intangibleLuminitoCategory
                let a1 = SKAction.moveBy(x: -(whoTouch.node?.frame.width)! * 0.025, y: 0, duration: 0.04)
                let a2 = SKAction.moveBy(x: (whoTouch.node?.frame.width)! * 0.05, y: 0, duration: 0.08)
                let a3 = SKAction.moveBy(x: -(whoTouch.node?.frame.width)! * 0.025, y: 0, duration: 0.04)
                
                let a4 = SKAction.moveBy(x: 0, y: -self.scene.size.height, duration: 0.5)
                
                let seq = [a1,a2,a3]
                whoTouch.node?.run(SKAction.repeat(SKAction.sequence(seq), count: 4), completion: {
                    
                    whoTouch.node?.run(a4, completion: {
                        self.gameOver()
                    })
                })
                
                break
                
            case electronCategory:
                energy += 10
                self.scene.enumerateChildNodes(withName: "electro") { (node, stop) in
                    //Sets electron new position
                    let yPos = arc4random_uniform(UInt32(self.scene.frame.height))
                    node.position = CGPoint(x: self.scene.frame.width, y: CGFloat(yPos))
                }
            default:
                break
            }
            
        }
        
    }
    
    //MARK: - Gesture Recognition
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let pos = touch.location(in: self.scene)
            
            
            luminito?.position.y = pos.y
            
            
        }
        
    }
    
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
//            addMeteor()
        }
    }
    
    func addMeteor(){
        
        let meteor = self.createRandomMeteor()
        
        meteor.name = "meteor"
        let yPos = arc4random_uniform(UInt32(self.scene.frame.height))
        let meteorPosition = CGPoint(x: self.scene.frame.width, y: CGFloat(yPos))
        meteor.position = meteorPosition
        let meteorPhysicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Asteroide Pequeno"), size: meteor.size)
        meteorPhysicsBody.categoryBitMask = meteorCategory
        meteorPhysicsBody.collisionBitMask = luminitoCategory | meteorCategory
        meteorPhysicsBody.contactTestBitMask = luminitoCategory
        
        meteorPhysicsBody.isDynamic = true
        meteorPhysicsBody.restitution = 1
        meteorPhysicsBody.linearDamping = 0
        meteor.physicsBody = meteorPhysicsBody
        self.scene.addChild(meteor)
        self.meteors.append(meteor)
        //adds the movement
        meteor.physicsBody?.velocity = CGVector(dx: meteor.initialVelocity, dy: 0)
        
        //        let timeInterval = TimeInterval(arc4random_uniform(10)+5)
        //        let animation = SKAction.moveTo(x: 0, duration: timeInterval)
        //        meteor.run(animation) {
        //            //after the completion of the animation, the node is removed from the screen and a new node is then added
        //            meteor.removeFromParent()
        //            self.addMeteor()
        //        }
    }
    
    func addElectron() {
        
        let electron = SKSpriteNode(imageNamed: "electron")
        electron.size = CGSize(width: electron.size.width*0.1, height: electron.size.height*0.1)
        electron.name = "electron"
        let yPos = arc4random_uniform(UInt32(self.scene.frame.height))
        electron.position = CGPoint(x: self.scene.frame.width, y: CGFloat(yPos))
        
        let electronPhysicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "electron"), size: electron.size)
        electronPhysicsBody.categoryBitMask = electronCategory
        electronPhysicsBody.collisionBitMask = luminitoCategory
        electronPhysicsBody.contactTestBitMask = luminitoCategory
        electronPhysicsBody.isDynamic = true
        electronPhysicsBody.linearDamping = 0
        electronPhysicsBody.velocity = CGVector(dx: -400, dy: 0)
        electron.physicsBody = electronPhysicsBody
        
        self.scene.addChild(electron)
        
        //        electron.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
    }
    
    func createRandomMeteor() -> SKMeteorNode {
        
        let texture: SKTexture?
        let size: CGSize?
        let xVelocity = -(Int(arc4random_uniform(200))+200)
        
        let type = Int(arc4random_uniform(2))
        
        if(type == 1){
            texture = SKTexture(imageNamed: "Asteroide Grande")
            size = CGSize(width: 50, height: 50)
        }else{
            texture = SKTexture(imageNamed: "Asteroide Pequeno")
            size = CGSize(width: 30, height: 30)
        }
        
        let meteor = SKMeteorNode(texture: texture!, initialVelocity: xVelocity, size: size!)
        
        return meteor
    }
    
    func gameOver(){
        //FIXME: - Low FPS when put Blur effect
        
        //                let  blur = CIFilter(name:"CIGaussianBlur",withInputParameters: ["inputRadius": 10.0])
        //                self.scene.filter = blur
        //                self.scene.shouldRasterize = true
        //                self.scene.shouldEnableEffects = true
        
        
        // Create an effects node with blur
        //        let effectsNode = SKEffectNode()
        //        let filter = CIFilter(name: "CIGaussianBlur")
        //        // Set the blur amount. Adjust this to achieve the desired effect
        //        let blurAmount = 10.0
        //        filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        //
        //        effectsNode.filter = filter
        //        effectsNode.position = CGPoint(x: 0, y: 0)
        //        effectsNode.blendMode = .alpha
        
        // Add the sprite to effects node to the sprite be blurred
        //        let nodes = self.scene.children
        //        self.scene.removeAllChildren()
        //        for node in nodes {
        //            self.gameover = true
        //            node.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        //            node.physicsBody = nil
        //            effectsNode.addChild(node)
        //        }
        //        self.scene.addChild(effectsNode)
        
        //Not blurred
        
        //Luminito Sad
        let sprite = SKSpriteNode(imageNamed: "Character Sad")
        sprite.position = CGPoint(x: self.scene.size.width * 0.5, y: self.scene.size.height * 1.5)
        sprite.size = CGSize(width: self.scene.size.width * 0.3 , height: self.scene.size.width * 0.3);
        sprite.zPosition = 100
        self.scene.addChild(sprite)
        let a = SKAction.move(to: CGPoint(x: self.scene.size.width * 0.5, y: self.scene.size.height * 0.65), duration: 2)
        sprite.run(a)
        
        //Home
        let home = SKSpriteNode(imageNamed: "Home Button")
        home.position = CGPoint(x: -(self.scene.size.width * 0.1), y: self.scene.size.height * 0.25)
        home.size = CGSize(width: self.scene.size.width * 0.08, height: self.scene.size.width * 0.08);
        home.zPosition = 100
        self.scene.addChild(home)
        let a2 = SKAction.move(to: CGPoint(x: self.scene.size.width * 0.45, y: self.scene.size.height * 0.25), duration: 0.3)
        home.run(a2)
        
        //Restart CheckPoint
        let restart = SKSpriteNode(imageNamed: "Home Button")
        restart.position = CGPoint(x: (self.scene.size.width * 1.1), y: self.scene.size.height * 0.25)
        restart.size = CGSize(width: self.scene.size.width * 0.08, height: self.scene.size.width * 0.08);
        restart.zPosition = 100
        self.scene.addChild(restart)
        let a3 = SKAction.move(to: CGPoint(x: self.scene.size.width * 0.55, y: self.scene.size.height * 0.25), duration: 0.3)
        restart.run(a3)
        
        //Game Over Label
        let gameOverlabel = SKLabelNode(fontNamed: "Avenir")
        gameOverlabel.fontSize = 50
        gameOverlabel.fontColor = UIColor.yellow
        gameOverlabel.horizontalAlignmentMode = .center
        gameOverlabel.verticalAlignmentMode = .bottom
        gameOverlabel.text = "GameOver"
        gameOverlabel.position = CGPoint(x: self.scene.size.width * 0.5, y: -(self.scene.size.height * 0.1))
        gameOverlabel.zPosition = 100
        self.scene.addChild(gameOverlabel)
        let a4 = SKAction.move(to: CGPoint(x: self.scene.size.width * 0.5, y: self.scene.size.height * 0.4), duration: 0.3)
        gameOverlabel.run(a4)
        
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
        self.scene.isPaused = false
        playing = true
        luminitoInteraction = true
    }
    
    func pause(){
        print("pause")
        self.scene.isPaused = true
        playing = false
        luminitoInteraction = false
    }
}

