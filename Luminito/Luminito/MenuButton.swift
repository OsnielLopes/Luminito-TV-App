//
//  MenuButton.swift
//  Luminito
//
//  Created by Vinícius Cano Santos on 09/06/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit
import SpriteKit

class MenuButton: SKSpriteNode {
    
    convenience init() {
        self.init()
    }
    
    override public var canBecomeFocused: Bool {
        get {
            return true
        }
    }
    
    // Adiciona o foco no botão
    func buttonDidGetFocus() {
        self.scale(to: CGSize(width: 154.0, height: 71.5))
    }
    
    // Retira o foco do botão
    func buttonDidLoseFocus() {
        self.scale(to: CGSize(width: 140.0, height: 65.0))
    }
}

