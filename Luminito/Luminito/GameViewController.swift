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
import GameController

class GameViewController: UIViewController {

    var gamePad :GCMicroGamepad?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gamePad = GCController.controllers().first?.microGamepad
        gamePad?.reportsAbsoluteDpadValues = true
        
        
        gamePad?.dpad.valueChangedHandler = { (dpad: GCControllerDirectionPad, xValue: Float, yValue: Float) -> Void in

            if dpad.up.isPressed {
                print("up")
            } else if dpad.down.isPressed {
                print("down")
            }
            
            
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
