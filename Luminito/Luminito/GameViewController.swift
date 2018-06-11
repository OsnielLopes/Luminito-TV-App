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

enum PlanetDistances: Int {
    
    /*
     
     Pluto - 5.913.520.000
     Neptune - 4.504.300.000
     Uranus - 2.870.990.000
     Saturn - 1.429.400.000
     Jupiter - 778.330.000
     Mars - 227.940.000
     Earth - 149.600.000
     Venus - 108.200.000
     Mercury - 57.910.000
     Sun - 0
     
     */
    
    case Sun = 0
    case mercury = 57910000
    case venus = 108200000
    case earth = 149600000
    case mars = 227940000
    case jupiter = 778330000
    case saturn = 1429400000
    case uranus = 2870990000
    case neptune = 4504300000
    case pluto = 5913520000
}

struct Planets {
    var name: String
    var distance: PlanetDistances
    var size: Int
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
    let powerUpCategory: UInt32 = 0x1 << 4
    var timer = Timer()
    
    var second = 0
    var velocity = CGFloat(1)
    
    var gameover = false
    var playing = true
    var luminitoInteraction = true
    var deltaTime = 0.0
    var deltaTimeTemp = 0.0
    var lastTime: TimeInterval = 0.0
    var randomGen = RandomGenerator()
    var parallaxManager = ParallaxManager()
    var planetsArray: [Planets] = []
    
    
    //MARK: - Managers
    var powerUpGenerator: PowerUpGenerator?
    
    //MARK: - Arrays
    var meteors:[SKMeteorNode] = []
    var backgrounds:[SKSpriteNode] = []
    
    //HUDs
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
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .bottom
        label.text = "0 N"
        return label
    }()
    
    var energyIndicatorBackgorund: SKShapeNode!
    var energyIndicator: SKShapeNode!
    
    var energy: Int = 90 {
        didSet {
            self.energyLabel.text = "\(energy) N"
                self.redrawEnergyIndicator()
        }
    }
    
    //MARK: - View Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fillPlanetsArray()
        self.powerUpGenerator = PowerUpGenerator(gameViewController: self)
        
        if let view = self.view as! SKView? {
            
            scene = SKScene(size: view.frame.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.delegate = self
            scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            scene.physicsWorld.contactDelegate = self
            self.addTapGestureRecognizer()
            
            //Set Background
            let background = SKSpriteNode(imageNamed: "SpaceBG")
            background.position = (self.view?.center)!
            background.zPosition = -5
            scene?.addChild(background)
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            //Set Star Parallax
            self.parallaxManager.startBackGroundParallaxSmallStars(view: scene.view!, sprite: "smallStars", zPosition: -4)
            self.parallaxManager.startBackGroundParallaxMediumSmall(view: scene.view!, sprite: "mediumSmallStars", zPosition: -3)
            
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
            self.energyLabel.position = CGPoint(x: (self.scene.frame.width * 0.95) - (self.energyLabel.frame.width/2), y: self.scene.frame.height * 0.95)
            self.scene.addChild(self.energyLabel)
            let rect = CGRect(x: 0, y: 0, width: self.scene.frame.width*0.2, height: self.scene.frame.height*0.03)
            self.energyIndicatorBackgorund = SKShapeNode(rect: rect, cornerRadius: 10)
            energyIndicatorBackgorund.position = CGPoint(x: self.scene.frame.width*0.7, y: self.scene.frame.height * 0.95)
            self.scene.addChild(energyIndicatorBackgorund)
            
            //add the tap recognizer
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
            view.addGestureRecognizer(tapRecognizer)
            
            //add the swipe recognizer
            let swipeGestureRocognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
            swipeGestureRocognizer.direction = .right
            view.addGestureRecognizer(swipeGestureRocognizer)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    var powerUpTime = 0
    //MARK: - SKSceneDelegate
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        
        self.parallaxManager.moveParallaxSmallStars(velocity: self.velocity)
        self.parallaxManager.moveParallaxSmallMedium(velocity: self.velocity * 3)
        
        if self.gameover == false {
            
            if distance < (self.planetsArray.last?.distance.rawValue)! {
                
                let planet = self.planetsArray.last
                guard let gameView = scene.view else {return}
                self.parallaxManager.startCelestialBody(view: gameView, sprite: (planet?.name)!, width: CGFloat((planet?.size)!), height: CGFloat((planet?.size)!), duration: 60, zPosition: -1)
                self.planetsArray.removeLast()
            }
            
            
            if (deltaTimeTemp >= 1.0) {
                //A second passed, 300.000 km traveled
                //self.distance -= 300000
                
                second += 1
                powerUpTime += 1
                
                if second == 30 {
                    if parallaxManager.isNebulaInScreen == false {
                        guard let gameView = scene.view else {return}
                        self.parallaxManager.startCelestialBody(view: gameView, sprite: "nebula", width: ((gameView.scene?.size.width)! * 6), height: ((gameView.scene?.size.height)! * 5.1), duration: 40, zPosition: -1)
                    }
                } else if second == 150 {
                    second = 0
                }
                
                if powerUpTime == 20 {
                    //Spawn PowerUp
                    self.addPowerUp()
                    powerUpTime = 0
                }
                
                deltaTimeTemp = 0
            }
            
            //Update calls it aproximally 9 times per second, so in one second is 35000 * 9 =˜ 300.000  km (1s c)
            if self.colectible == .velocityBoost {
                distance -= 105000
            } else {
                distance -= 35000
            }
            
            deltaTime = 0.0
            deltaTime = currentTime - lastTime
            lastTime = currentTime
            deltaTimeTemp += deltaTime
            
        } else {
            //GameOver, return distance, there's some frames lost, so we have to increase distance amount per frame
            //distance += 35000
        }
        
        scene.enumerateChildNodes(withName: "meteor") { (node, stop) in
            guard let meteor = node as? SKMeteorNode else {
                print("Impossible to convert the node to a SKMeteorNode")
                return
            }
            
            //If meteor is off the Scene
            if !((self.scene.view?.frame.contains(meteor.position))!) {
                
                //Sets meteor new position
                let yPos = arc4random_uniform(UInt32(self.scene.frame.height))
                
                if self.gameover {
                    meteor.position = CGPoint(x: 0, y: CGFloat(yPos))
                } else {
                    meteor.position = CGPoint(x: self.scene.frame.width, y: CGFloat(yPos))
                }
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
                electron.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
            }
        }
        //}
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
                
                self.gameOver()
                //
                //                for meteor in self.meteors {
                //                    meteor.physicsBody = nil
                //                }
                //
                //                whoTouch.categoryBitMask = intangibleLuminitoCategory
                //                let a1 = SKAction.moveBy(x: -(whoTouch.node?.frame.width)! * 0.025, y: 0, duration: 0.04)
                //                let a2 = SKAction.moveBy(x: (whoTouch.node?.frame.width)! * 0.05, y: 0, duration: 0.08)
                //                let a3 = SKAction.moveBy(x: -(whoTouch.node?.frame.width)! * 0.025, y: 0, duration: 0.04)
                //
                //                let a4 = SKAction.moveBy(x: 0, y: -self.scene.size.height, duration: 0.5)
                //
                //                let seq = [a1,a2,a3]
                //                whoTouch.node?.run(SKAction.repeat(SKAction.sequence(seq), count: 4), completion: {
                //
                //                    whoTouch.node?.run(a4, completion: {
                //                        self.gameOver()
                //                    })
                //                })
                
                
                
                break
            default:
                break
            }
            
        } else if wasTouched.categoryBitMask == powerUpCategory {
            //Something touched PowerUp
            
            guard let powerUpsNames = self.powerUpGenerator?.powerUpNames else {return}
            guard let powerUps = self.powerUpGenerator?.powerUps else {return}
            
            guard let i = powerUpsNames.index(of: (wasTouched.node?.name)!) else {return}
            self.colectible = powerUps[i]
            
            wasTouched.node?.removeFromParent()
            
        } else if wasTouched.categoryBitMask == electronCategory {
            wasTouched.node?.removeFromParent()
            self.addElectron(increasingEnergy: true)
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
        
        if self.gameover == false {
            switch self.colectible {
            case .intangibility:
                
                self.powerUpGenerator?.activateIntangibilityPowerUp()
                print("Intangibility Engaged")
                
            case .velocityBoost:
                
                self.powerUpGenerator?.activateVelocityBoostPowerUp()
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
        }
        
        self.scene.enumerateChildNodes(withName: "meteor") { (node, end) in
            guard let meteor = node as? SKSpriteNode else {
                return
            }
        }
        
    }
    
    @objc func didSwipe() {
        if energy == 100 {
            energy = 0
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
    
    func addElectron(increasingEnergy: Bool = false) {
        
        if nil == self.scene.childNode(withName: "electron") {
            
            self.energy += increasingEnergy && energy < 100 ? 10 : 0
            
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
            electronPhysicsBody.velocity = CGVector(dx: -100, dy: 0)
            electron.physicsBody = electronPhysicsBody
            
            self.scene.addChild(electron)
        }
        
    }
    
    func addPowerUp() {
        let tuple = self.powerUpGenerator?.generatePowerUp()
        self.colectible = (tuple?.colectible)!
        
        //Add movement and physics
        let powerUp = SKSpriteNode(imageNamed: (tuple?.name)!)
        powerUp.name = tuple?.name
        powerUp.size = CGSize(width: powerUp.size.width * 0.4, height: powerUp.size.height * 0.4)
        let y = self.randomGen.generateRandomNumber(min: 0, max: Int(self.scene.frame.height))
        powerUp.position = CGPoint(x: Int(self.scene.frame.width), y: y)
        let action = SKAction.move(to: CGPoint(x: -powerUp.size.width, y: CGFloat(y)), duration: 20)
        
        let powerUpPhysicsBody = SKPhysicsBody(texture: powerUp.texture!, size: powerUp.size)
        powerUpPhysicsBody.categoryBitMask = powerUpCategory
        powerUpPhysicsBody.collisionBitMask = luminitoCategory
        powerUpPhysicsBody.contactTestBitMask = luminitoCategory
        powerUpPhysicsBody.isDynamic = true
        
        powerUp.physicsBody = powerUpPhysicsBody
        
        self.scene.addChild(powerUp)
        powerUp.run(action)
    }
    
    func createRandomMeteor() -> SKMeteorNode {
        
        let texture: SKTexture?
        let size: CGSize?
        let xVelocity = -(Int(arc4random_uniform(100))+100)
        
        let type = Int(arc4random_uniform(2))
        
        if(type == 1){
            texture = SKTexture(imageNamed: "Asteroide Grande")
            size = CGSize(width: 100, height: 100)
        }else if(type == 2){
            texture = SKTexture(imageNamed: "Asteroide Grande")
            size = CGSize(width: 60, height: 60)
        }else{
            texture = SKTexture(imageNamed: "Asteroide Pequeno")
            size = CGSize(width: 40, height: 40)
        }
        
        let meteor = SKMeteorNode(texture: texture!, initialVelocity: xVelocity, size: size!)
        
        return meteor
    }
    
    func fillPlanetsArray() {
        let mercury = Planets(name: "Mercurio 2", distance: PlanetDistances.mercury, size: 50)
        self.planetsArray.append(mercury)
        let venus = Planets(name: "Venus 2", distance: PlanetDistances.venus, size: 90)
        self.planetsArray.append(venus)
        let earth = Planets(name: "Terra 2", distance: PlanetDistances.earth, size: 100)
        self.planetsArray.append(earth)
        let mars = Planets(name: "Marte 2", distance: PlanetDistances.mars, size: 80)
        self.planetsArray.append(mars)
        let jupiter = Planets(name: "Jupiter 2", distance: PlanetDistances.jupiter, size: 200)
        self.planetsArray.append(jupiter)
        let saturn = Planets(name: "Saturno 2", distance: PlanetDistances.saturn, size: 180)
        self.planetsArray.append(saturn)
        let uranus = Planets(name: "Urano 2", distance: PlanetDistances.uranus, size: 150)
        self.planetsArray.append(uranus)
        let neptune = Planets(name: "Netuno 2", distance: PlanetDistances.neptune, size: 140)
        self.planetsArray.append(neptune)
        let pluto = Planets(name: "Plutao 2", distance: PlanetDistances.pluto, size: 40)
        self.planetsArray.append(pluto)
    }
    
    func gameOver(){
        
        //Luminito Sad
        //        let sprite = SKSpriteNode(imageNamed: "Character Sad")
        //        sprite.position = CGPoint(x: self.scene.size.width * 0.5, y: self.scene.size.height * 1.5)
        //        sprite.size = CGSize(width: self.scene.size.width * 0.3 , height: self.scene.size.width * 0.3);
        //        sprite.zPosition = 100
        //        self.scene.addChild(sprite)
        //        let a = SKAction.move(to: CGPoint(x: self.scene.size.width * 0.5, y: self.scene.size.height * 0.65), duration: 2)
        //        sprite.run(a)
        //
        //        //Home
        //        let home = SKSpriteNode(imageNamed: "Home Button")
        //        home.position = CGPoint(x: -(self.scene.size.width * 0.1), y: self.scene.size.height * 0.25)
        //        home.size = CGSize(width: self.scene.size.width * 0.08, height: self.scene.size.width * 0.08);
        //        home.zPosition = 100
        //        self.scene.addChild(home)
        //        let a2 = SKAction.move(to: CGPoint(x: self.scene.size.width * 0.45, y: self.scene.size.height * 0.25), duration: 0.3)
        //        home.run(a2)
        //
        //        //Restart CheckPoint
        //        let restart = SKSpriteNode(imageNamed: "Home Button")
        //        restart.position = CGPoint(x: (self.scene.size.width * 1.1), y: self.scene.size.height * 0.25)
        //        restart.size = CGSize(width: self.scene.size.width * 0.08, height: self.scene.size.width * 0.08);
        //        restart.zPosition = 100
        //        self.scene.addChild(restart)
        //        let a3 = SKAction.move(to: CGPoint(x: self.scene.size.width * 0.55, y: self.scene.size.height * 0.25), duration: 0.3)
        //        restart.run(a3)
        //
        //        //Game Over Label
        //        var gameOverlabel = SKLabelNode(fontNamed: "Avenir")
        //        gameOverlabel.fontSize = 50
        //        gameOverlabel.fontColor = UIColor.yellow
        //        gameOverlabel.horizontalAlignmentMode = .center
        //        gameOverlabel.verticalAlignmentMode = .bottom
        //        gameOverlabel.text = "GameOver"
        //        gameOverlabel.position = CGPoint(x: self.scene.size.width * 0.5, y: -(self.scene.size.height * 0.1))
        //        gameOverlabel.zPosition = 100
        //        self.scene.addChild(gameOverlabel)
        //        let a4 = SKAction.move(to: CGPoint(x: self.scene.size.width * 0.5, y: self.scene.size.height * 0.4), duration: 0.3)
        //        gameOverlabel.run(a4)
        
        self.gameover = true
        
        for meteor in self.meteors {
            meteor.physicsBody?.velocity = CGVector(dx: meteor.initialVelocity * -10, dy: 0)
        }
        
        self.luminito?.physicsBody?.categoryBitMask = intangibleLuminitoCategory
        self.velocity *= -10
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(stop)), userInfo: nil, repeats: false)
        
        if self.parallaxManager.isNebulaInScreen == true {
            self.scene.enumerateChildNodes(withName: "nebula") { (node, end) in
                guard let nebula = node as? SKSpriteNode else {
                    return
                }
                
                nebula.run(SKAction.fadeOut(withDuration: 1), completion: {
                    nebula.removeFromParent()
                })
            }
        }
        
    }
    
    @objc func stop() {
        self.gameover = false
        self.velocity /= -10
        
        self.luminito?.run(SKAction.wait(forDuration: 5), completion: {
            self.luminito?.physicsBody?.categoryBitMask = self.luminitoCategory
        })
        
        for meteor in self.meteors {
            meteor.physicsBody?.velocity = CGVector(dx: meteor.initialVelocity, dy: 0)
        }
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
    
    func redrawEnergyIndicator(){
        if energyIndicator != nil {
            energyIndicator.removeFromParent()
        }
        if energy > 0 {
            let rect = CGRect(x: 0, y: 0, width: self.scene.frame.width*0.2*CGFloat(energy > 100 ? 100 : energy)/100.0, height: self.scene.frame.height*0.03)
            energyIndicator = SKShapeNode(rect: rect, cornerRadius: 10)
            energyIndicator.position = CGPoint(x: self.scene.frame.width*0.7, y: self.scene.frame.height * 0.95)
            energyIndicator.fillColor = .yellow
            self.scene.addChild(energyIndicator)
        }
    }
}

