//
//  SuperBomb.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 8/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class SuperBomb: CCSprite {
    var explosion = CCBReader.load("Explosion 2") as! Explosion2
    
    func startExplosion(c :CCPhysicsNode){
        explosion.scale = 3
        c.addChild(explosion)
        explosion.position = self.position
    }
}
