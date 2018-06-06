//
//  GameScene.swift
//  Luminito
//
//  Created by Osniel Lopes Teixeira on 28/05/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit

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

class GameScene: SKScene {
    
    var randomGen = RandomGenerator()
    var parallaxManager = ParallaxManager()
    var planetsArray: [Planets] = []
    
    override func didMove(to view: SKView) {
        
        self.fillPlanetsArray()
        
        guard let gameView = self.view else {return}
        
        let background = SKSpriteNode(imageNamed: "SpaceBG")
        background.position = (self.view?.center)!
        background.zPosition = -5
        self.view?.scene?.addChild(background)
        
        self.parallaxManager.startBackGroundParallax(view: gameView, sprite: "smallStars", duration: 500, zPosition: -4)
        self.parallaxManager.startBackGroundParallax(view: gameView, sprite: "mediumSmallStars", duration: 250, zPosition: -3)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
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

    var deltaTimeTempForNebula = 0.0
    var lastTime: TimeInterval = 0.0
    
    override func update(_ currentTime: TimeInterval) {
        
        var distance = 0
        /*Spawn planets Example: (if distance == x {spawnPlanet})
        
        if distance < (self.planetsArray.last?.distance.rawValue)! {
            
            let planet = self.planetsArray.last
            guard let gameView = self.view else {return}
            self.parallaxManager.startCelestialBody(view: gameView, sprite: (planet?.name)!, width: CGFloat((planet?.size)!), height: CGFloat((planet?.size)!), duration: 60, zPosition: -2)
            self.planetsArray.removeLast()
        }
 
        */
        
        
        //This needs to be the last to avoid return before something
        let deltaTime = currentTime - lastTime
        if (deltaTime > deltaTimeTempForNebula) {
            print(deltaTime)
            guard let gameView = self.view else {return}
            if parallaxManager.isNebulaInScreen == false {
                
                self.deltaTimeTempForNebula = Double(self.randomGen.generateRandomNumber(min: 30, max: 60))
                
//                self.parallaxManager.startCelestialBody(view: gameView, sprite: "nebula", width: ((gameView.scene?.size.width)! * 4), height: ((gameView.scene?.size.height)! * 3.4), duration: 20, zPosition: -1)
                
                let planet = self.planetsArray.last
                self.parallaxManager.startCelestialBody(view: gameView, sprite: (planet?.name)!, width: CGFloat((planet?.size)!), height: CGFloat((planet?.size)!), duration: 60, zPosition: -2)
            }

        } else {
            return
        }
        lastTime = currentTime
    }
 
}


