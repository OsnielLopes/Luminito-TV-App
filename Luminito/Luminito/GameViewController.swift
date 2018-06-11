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
    var luminito = SKSpriteNode(imageNamed: "Character Wow")
    
    //MARK: - Variables
    var scene: SKScene!
    
    let menu = Menu()
    var luminitoLabel = SKSpriteNode(imageNamed: "Titulo_inicial")
    var foreveLabel = SKSpriteNode(imageNamed: "Forever")
    var playButton = MenuButton(imageNamed: "Menu Play Button")
    var buttons = [MenuButton]()
    var currentPowerUp: SKSpriteNode?
    
    var colectible: Colectible = .none
    let luminitoCategory: UInt32 = 0x1 << 0
    let meteorCategory: UInt32 = 0x1 << 1
    let intangibleLuminitoCategory: UInt32 = 0x1 << 2
    let electronCategory: UInt32 = 0x1 << 3
    let powerUpCategory: UInt32 = 0x1 << 4
    var timer = Timer()
    
    var gameover = false
    var playing = true
    var luminitoInteraction = false
    var distanceUpdate = false
    var deltaTime = 0.0
    var deltaTimeTemp = 0.0
    var lastTime: TimeInterval = 0.0
    var randomGen = RandomGenerator()
    var parallaxManager = ParallaxManager()
    var planetsArray: [Planets] = []
    var gameStartAux = false
    
    //Difficulty Variables
    var qtdeMeteors = 5
    var second = 0
    var velocity = CGFloat(1)
    var powerUpTime = 0
    var timeForAddMeteor = 0
    
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
    
    var distance: Int = UserDefaults.standard.integer(forKey: "distance") != 0 ? UserDefaults.standard.integer(forKey: "distance") : 6000000000 {
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
            
            //Set menu
            luminitoLabel.name = "Luminito Label"
            luminitoLabel.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.frame.size.height)! * 0.75)
            luminitoLabel.size = CGSize(width: 540.0, height: 150.0)
            self.scene.addChild(luminitoLabel)
            
            foreveLabel.name = "Forever Label"
            foreveLabel.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.frame.size.height)! * 0.60)
            foreveLabel.size = CGSize(width: 400.0, height: 120.0)
            self.scene.addChild(foreveLabel)
            
            playButton.name = "Play Button"
            playButton.position = CGPoint(x: (scene?.frame.size.width)!, y: (scene?.frame.size.height)! * 0.40)
            playButton.size = CGSize(width: 250.0, height: 120.0)
            playButton.isUserInteractionEnabled = true
            buttons.append(playButton)
            self.scene.addChild(playButton)
            
            
            self.currentPowerUp = SKSpriteNode()
            currentPowerUp?.zPosition = 300
            currentPowerUp?.size = CGSize(width: 50, height: 50)
            currentPowerUp?.alpha = 0.8
            currentPowerUp?.position = CGPoint(x: self.scene.size.width * 0.95, y: self.scene.size.height * 0.05)
            self.scene.addChild(currentPowerUp!)
            
            //adds the luminito node
            luminito.name = "Luminito"
            let position = CGPoint(x: -(scene?.size.width)!/1.4, y: self.scene.size.height/2)
            luminito.position = position
            let luminitoPhysicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Character Wow"), size: CGSize(width: 150.0, height: 150.0))
            luminitoPhysicsBody.categoryBitMask = luminitoCategory
            luminitoPhysicsBody.collisionBitMask = meteorCategory
            
            luminitoPhysicsBody.isDynamic = false
            luminito.physicsBody = luminitoPhysicsBody
            
            let range = SKRange(lowerLimit: 50, upperLimit: scene.frame.height - 50)
            let topAndBottomLocker = SKConstraint.positionY(range)
            
            luminito.constraints = [ topAndBottomLocker ]
            luminito.isUserInteractionEnabled = true
            
            self.scene.addChild(luminito)
            
            //Menu
            let menu = Menu(gameScene: self.scene)
            menu.moveMenuToCenter(gameScene: self.scene)
            
            //addSelectRecognizer()
            addMenuRecognizer()
            
            
            
            //add HUD
            self.distanceLabel.position = CGPoint(x: self.scene.frame.width * 0.18, y: self.scene.frame.height * 0.90)
            self.distanceLabel.zPosition = 1000
            self.scene.addChild(self.distanceLabel)
            self.energyLabel.position = CGPoint(x: (self.scene.frame.width * 0.95) - (self.energyLabel.frame.width/2), y: self.scene.frame.height * 0.90)
            self.scene.addChild(self.energyLabel)
            let rect = CGRect(x: 0, y: 0, width: self.scene.frame.width*0.2, height: self.scene.frame.height*0.03)
            self.energyIndicatorBackgorund = SKShapeNode(rect: rect, cornerRadius: 10)
            energyIndicatorBackgorund.position = CGPoint(x: self.scene.frame.width*0.7, y: self.scene.frame.height * 0.90)
            energyIndicatorBackgorund.zPosition = 1000
            self.scene.addChild(energyIndicatorBackgorund)
            
            
            if (playing == true){
                addSelectRecognizer()
            }
            
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
    
    //MARK: - SKSceneDelegate
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        
        self.parallaxManager.moveParallaxSmallStars(velocity: self.velocity)
        self.parallaxManager.moveParallaxSmallMedium(velocity: self.velocity * 3)
        
        if self.menu.gameStarted == true {
            
            if self.gameStartAux == false {
                addMeteors(qtde: self.qtdeMeteors)
                addElectron()
                
                self.gameStartAux = true
            }
        
        if self.gameover == false {
            
            if distance < (self.planetsArray.last?.distance.rawValue)! {
                
                let planet = self.planetsArray.last
                guard let gameView = scene.view else {return}
                self.parallaxManager.startCelestialBody(view: gameView, sprite: (planet?.name)!, width: CGFloat((planet?.size)!), height: CGFloat((planet?.size)!), duration: 60, zPosition: -1)
                self.planetsArray.removeLast()
            }
            
            
            if (deltaTimeTemp >= 1.0) {
                //A second passed, 300.000 km traveled
                
                //INCREASE DIFFICULTY
                
                //1,5 in velocity each 5 minutes
                self.velocity += 0.005
                
                //Each 15 minutes
                if timeForAddMeteor == 600 {
                    self.qtdeMeteors += 1
                    
                    for meteor in self.meteors {
                        meteor.removeFromParent()
                    }
                    self.meteors = []
                    
                    self.addMeteors(qtde: self.qtdeMeteors)
                }
                
                
                timeForAddMeteor += 1
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
            if (distanceUpdate == true){
                if self.colectible == .velocityBoost {
                    distance -= 105000
                } else {
                    distance -= 35000
                }
            }
            
            if self.powerUpGenerator?.isMagnetActive == true {
                let nodes = self.scene.children
                for node in nodes {
                    if node.name == "electron" {
                        
                        let d = node.position.distance(to: luminito.position)
                        node.run(SKAction.move(to: self.luminito.position, duration: TimeInterval(d/200)))
                        
                    }
                }
            }
            
            deltaTime = 0.0
            deltaTime = currentTime - lastTime
            lastTime = currentTime
            deltaTimeTemp += deltaTime
            
        } else {
            //GameOver, return distance, there's some frames lost, so we have to increase distance amount per frame
            distance += 35000
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
//
//            if self.gameover == false {
//                meteor.physicsBody?.velocity = CGVector(dx: meteor.initialVelocity, dy: 0)
//            }
            
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
        
        UserDefaults.standard.set(distance, forKey: "distance")
            
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
                self.gameOver()
                break
            default:
                break
            }
            
        } else if wasTouched.categoryBitMask == powerUpCategory {
            
            
            //Something touched PowerUp
            guard let n = wasTouched.node as! SKSpriteNode? else {return}
            
            guard let powerUpsNames = self.powerUpGenerator?.powerUpNames else {return}
            guard let powerUps = self.powerUpGenerator?.powerUps else {return}
            
            guard let i = powerUpsNames.index(of: (wasTouched.node?.name)!) else {return}
            self.colectible = powerUps[i]
            
            wasTouched.node?.removeAllActions()
            
            
            let act1 = SKAction.scale(to: 1.5, duration: 0.7)
            let act2 = SKAction.scale(to: 0, duration: 0.3)
            let seq = SKAction.sequence([act1,act2])
            
            wasTouched.node?.run(seq, completion: {
                wasTouched.node?.removeFromParent()
            })
            
            wasTouched.node?.physicsBody = nil
            self.currentPowerUp?.texture = n.texture
            
        } else if wasTouched.categoryBitMask == electronCategory {
            wasTouched.node?.removeFromParent()
            self.addElectron(increasingEnergy: true)
        }
        
    }
    
    
    //MARK: - Gesture Recognition
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if(luminitoInteraction == true){
                let pos = touch.location(in: self.scene)
                luminito.position.y = pos.y
            }
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
                    
                    self.powerUpGenerator?.activateMeteorDestroyerPowerUp()
                    print("Destroyer Engaged")
                    
                case .magnet:
                    
                    self.powerUpGenerator?.activateMagnetPowerUp()
                    print("not allowed yet")
                    
                case .oneMoreLife:
                    
                    self.powerUpGenerator?.activateOneMoreLifePowerUp()
                    print("not allowed yet")
                    
                case .none:
                    print("powerUps disabled")
                }
            
        }
    }
    
    @objc func didSwipe() {
        if energy == 100 {
            energy = 0
            //finds the closer meteor
            var closerMeteor: SKNode?
            var rangeOfSearch: CGFloat = 0.5
            repeat {
                self.scene.enumerateChildNodes(withName: "meteor") { (node, stop) in
                    if node.position.x > self.luminito.position.x && node.position.y > self.luminito.position.y - self.scene.size.height * rangeOfSearch && node.position.y < self.luminito.position.y + self.scene.size.height * rangeOfSearch{
                        if closerMeteor == nil {
                            closerMeteor = node
                        } else if (node.position.distance(to: self.luminito.position) < (closerMeteor?.position.distance(to: self.luminito.position))!){
                            closerMeteor = node
                        }
                    }
                }
                rangeOfSearch += 0.5
            } while(closerMeteor == nil)
            
            
            //creates a shot and an action
            let shot = SKSpriteNode(imageNamed: "electron")
            shot.size = CGSize(width: shot.size.width*0.1, height: shot.size.height*0.1)
            shot.position = luminito.position
            self.scene.addChild(shot)
            var closerMeteorPosition = closerMeteor!.position
            closerMeteorPosition.x -= 100
            let action = SKAction.move(to: closerMeteorPosition, duration: TimeInterval(self.luminito.position.distance(to: closerMeteorPosition)/600))
            shot.run(action) {
                shot.removeFromParent()
                closerMeteor?.removeFromParent()
                self.addMeteor()
            }
        }
    }
    
    //MARK: - Auxiliar Functions
    func addMeteors(qtde: Int) {
        for _ in 0..<qtde{
            addMeteor()
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
        meteorPhysicsBody.collisionBitMask = luminitoCategory //| meteorCategory
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
            electronPhysicsBody.collisionBitMask = luminitoCategory | intangibleLuminitoCategory
            electronPhysicsBody.contactTestBitMask = luminitoCategory | intangibleLuminitoCategory
            electronPhysicsBody.isDynamic = true
            electronPhysicsBody.linearDamping = 0
            electronPhysicsBody.velocity = CGVector(dx: -100, dy: 0)
            electron.physicsBody = electronPhysicsBody
            
            self.scene.addChild(electron)
        }
        
    }
    
    func addPowerUp() {
        let tuple = self.powerUpGenerator?.generatePowerUp()
        
        //Add movement and physics
        let powerUp = SKSpriteNode(imageNamed: (tuple?.name)!)
        powerUp.name = tuple?.name
        powerUp.zPosition = 300
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
        powerUp.run(action) {
            powerUp.removeFromParent()
        }
    }
    
    func createRandomMeteor() -> SKMeteorNode {
        
        let texture: SKTexture?
        let size: CGSize?
        let xVelocity = -(Int(arc4random_uniform(100))+100+Int(velocity * 2))
        
        let type = Int(arc4random_uniform(2))
        
        if(type == 1){
            texture = SKTexture(imageNamed: "Asteroide Grande")
            size = CGSize(width: 100, height: 100)
        }else if(type == 2){
            texture = SKTexture(imageNamed: "Asteroide Grande")
            size = CGSize(width: 60, height: 60)
        }else{
            texture = SKTexture(imageNamed: "Asteroide Pequeno")
            size = CGSize(width: 50, height: 50)
        }
        
        let meteor = SKMeteorNode(texture: texture!, initialVelocity: xVelocity, size: size!)
        
        return meteor
    }
    
    func fillPlanetsArray() {
        let mercury = Planets(name: "Mercurio 2", distance: PlanetDistances.mercury, size: 80)
        self.planetsArray.append(mercury)
        let venus = Planets(name: "Venus 2", distance: PlanetDistances.venus, size: 120)
        self.planetsArray.append(venus)
        let earth = Planets(name: "Terra 2", distance: PlanetDistances.earth, size: 120)
        self.planetsArray.append(earth)
        let mars = Planets(name: "Marte 2", distance: PlanetDistances.mars, size: 100)
        self.planetsArray.append(mars)
        let jupiter = Planets(name: "Jupiter 2", distance: PlanetDistances.jupiter, size: 200)
        self.planetsArray.append(jupiter)
        let saturn = Planets(name: "Saturno 2", distance: PlanetDistances.saturn, size: 180)
        self.planetsArray.append(saturn)
        let uranus = Planets(name: "Urano 2", distance: PlanetDistances.uranus, size: 160)
        self.planetsArray.append(uranus)
        let neptune = Planets(name: "Netuno 2", distance: PlanetDistances.neptune, size: 150)
        self.planetsArray.append(neptune)
        let pluto = Planets(name: "Plutao 2", distance: PlanetDistances.pluto, size: 70)
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
        
        self.energy = 0
        
        for meteor in self.meteors {
            meteor.physicsBody?.velocity = CGVector(dx: meteor.initialVelocity * -10, dy: 0)
        }
        
        self.luminito.physicsBody?.categoryBitMask = intangibleLuminitoCategory
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
        
        self.luminito.run(SKAction.wait(forDuration: 3), completion: {
            self.luminito.physicsBody?.categoryBitMask = self.luminitoCategory
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
        self.distanceUpdate = true
        
    }
    
    func pause(){
        print("pause")
        self.scene.isPaused = true
        playing = false
        luminitoInteraction = false
        distanceUpdate = false
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
                menu.playTapped(gameScene: self.scene)
                
                //add the tap recognizer
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
                view.addGestureRecognizer(tapRecognizer)
                
                luminitoInteraction = true
                playing = true
                distanceUpdate = true
            }
        }
        
    }
    var gameStarted = false
    // Executa quando o botão menu do remote é pressionado
    @objc func menuPressed(sender: AnyObject){
        if(playing == true){
            menu.menuTapped(gameScene: self.scene)
            addSelectRecognizer()
            stop()
            //pause()
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
    
    func redrawEnergyIndicator(){
        if energyIndicator != nil {
            energyIndicator.removeFromParent()
        }
        if energy > 0 {
            let rect = CGRect(x: 0, y: 0, width: self.scene.frame.width*0.2*CGFloat(energy > 100 ? 100 : energy)/100.0, height: self.scene.frame.height*0.03)
            energyIndicator = SKShapeNode(rect: rect, cornerRadius: 10)
            energyIndicator.position = CGPoint(x: self.scene.frame.width*0.7, y: self.scene.frame.height * 0.90)
            energyIndicator.zPosition = 1000
            energyIndicator.fillColor = .yellow
            self.scene.addChild(energyIndicator)
        }
    }
}

