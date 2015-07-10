//
//  Gameplay.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    weak var loadPercentage: CCLabelTTF!
    weak var computer :CCSprite!
    weak var gamePhysicsNode :CCPhysicsNode!
    var viruses :[Virus] = []
    
    func didLoadFromCCB(){
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        
        for i in 0..<2{
            var virus1 = CCBReader.load("Virus1") as! Virus
            var virus2 = CCBReader.load("Virus2") as! Virus
            
            virus1.position = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: (UIScreen.mainScreen().bounds.height / 2) - 75)
            virus2.position = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: UIScreen.mainScreen().bounds.height - 75)
            
            virus1.spawn = .Bottom
            virus2.spawn = .Top
            
            virus1.scaleX = 0.015
            virus1.scaleY = 0.015
            virus2.scaleX = 0.015
            virus2.scaleY = 0.015
            
            gamePhysicsNode.addChild(virus1)
            gamePhysicsNode.addChild(virus2)
            
            
            virus1.physicsBody.velocity = ccp(0, 10)
            virus2.physicsBody.velocity = ccp(0, -10)
            
            viruses.append(virus1)
            viruses.append(virus2)
        }
    }
    
    func virusMovementDirection(virus :Virus){
        if virus.spawn == .Top {
            virus.physicsBody.velocity = ccp(0, -10)
        }
    }
    
    
}