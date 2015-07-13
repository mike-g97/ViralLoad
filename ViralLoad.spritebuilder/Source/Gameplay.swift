//
//  Gameplay.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    enum GameStates {
        case Title, Playing, GameOver
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    weak var loadPercentage :CCLabelTTF!
    weak var score :CCLabelTTF!
    weak var computer :CCSprite!
    weak var gamePhysicsNode :CCPhysicsNode!
    var viruses :[Virus] = []
    var gameStates :GameStates = .Title
    
    var load :Int = 0{
        didSet{
            loadPercentage.string = "\(load)"
        }
    }
    
    var currentScore :Int = 0{
        didSet{
            score.string = "\(currentScore)"
        }
    }
    
    func didLoadFromCCB(){
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        
        start()
        
    }
    
    func start(){
        gameStates = .Playing
        
        for i in 0..<10{
            spawnVirus()
        }
    }
    
    
    override func update(delta: CCTime) {
        var randomSpawner = arc4random_uniform(101)
        
        if randomSpawner <= 10 {
            spawnVirus()
        }
        
        
//        sleep(1)
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        for virus in viruses {
            
            var virusWorldSpace = convertToWorldSpace(virus.position)

            if Int(abs(touch.locationInWorld().x - virusWorldSpace.x)) <= 60
            && Int(abs(touch.locationInWorld().y - virusWorldSpace.y)) <= 60 {

                viruses.removeAtIndex(find(viruses, virus)!)
//               virus.color = CCColor.blackColor()
                virus.removeFromParent()
                currentScore++
            }
            
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, virus: Virus!, computer: CCNode!) -> Bool {
        if isGameOver() {
            triggerGameOver()
        }else if !isGameOver(){
            viruses.removeAtIndex(find(viruses, virus)!)
            virus.removeFromParent()
            load = load + 20
        }
        return true
    }
    
//  Spawn virus at a time on either four sides of the screen randomly
    func spawnVirus(){
        let virusType = Int(arc4random_uniform(2))
        let screenSide = Int(arc4random_uniform(4))
        let percent = Float(arc4random_uniform(101)) / 100
        var virus :Virus!
        var x :CGFloat!
        var y :CGFloat!
//        println("screen side: \(screenSide)")
//        println("percent: \(percent) and percent CGFloat \(CGFloat(percent))")
//        println("")
        
//      Generate random type
        if virusType == 0{
            virus = CCBReader.load("Virus1") as! Virus
            virus.scaleX = 0.015
            virus.scaleY = 0.015
            gamePhysicsNode.addChild(virus)
        } else if virusType == 1{
            virus = CCBReader.load("Virus2") as! Virus
            virus.scaleX = 0.015
            virus.scaleY = 0.015
            gamePhysicsNode.addChild(virus)
        }
        
        
//      Generate position on either four sides of the screen
        if screenSide == 0{
            //Top
            x = UIScreen.mainScreen().bounds.width * CGFloat(percent)
            y = UIScreen.mainScreen().bounds.height
            virus.position = CGPoint(x: x, y: y)
        }else if screenSide == 1{
            //Bottom
            x = UIScreen.mainScreen().bounds.width * CGFloat(percent)
            y = 0.0
            virus.position = CGPoint(x: x, y: y)
        }else if screenSide == 2{
            //Left
            x = 0.0
            y = UIScreen.mainScreen().bounds.height * CGFloat(percent)
            virus.position = CGPoint(x: x, y: y)
        }else if screenSide == 3{
            //Right
            x = UIScreen.mainScreen().bounds.width
            y = UIScreen.mainScreen().bounds.height * CGFloat(percent)
            virus.position = CGPoint(x: x, y: y)
        }
        
        virusMovementDirection(virus)
        viruses.append(virus)
    }


//  Sets velocity according to it's spawn position on the screen
    func virusMovementDirection(virus :Virus){
        var x = CGFloat(computer.position.x - virus.position.x) / 10
        var y = CGFloat(computer.position.y - virus.position.y) / 10
        
        virus.physicsBody.velocity = ccp(x, y)
    }
    
    func triggerGameOver(){
        gameStates = .GameOver
        
    }
    
    func isGameOver() -> Bool{
        if load < 100{
            return false
        }
        return true
    }
    

    
}