//
//  Extensions.swift
//  Luminito
//
//  Created by Osniel Lopes Teixeira on 10/06/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat{
        let deltaX = self.x - point.x
        let deltaY = self.y - point.y
        return sqrt(pow(deltaX, 2)+pow(deltaY, 2))
    }
}
