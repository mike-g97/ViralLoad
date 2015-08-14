//
//  Bomb.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 8/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Bomb: CCSprite {
    var explosion = CCBReader.load("Explosion 1") as! Explosion1
    
    func startExplosion(c :CCPhysicsNode){
        c.addChild(explosion)
        explosion.position = self.position
    }
}
