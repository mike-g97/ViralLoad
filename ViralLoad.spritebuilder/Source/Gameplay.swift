//
//  Gameplay.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    enum GameStates {
        case Title, Playing, GameOver
    }
    
    weak var loadPercentage :CCLabelTTF!
    weak var score :CCLabelTTF!
    weak var computer :CCSprite!
    weak var gamePhysicsNode :CCPhysicsNode!
    var viruses :[Virus] = []
    var gameStates :GameStates = .Title
    var virusSpeed :Int = 10
    
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
        
//        for virus in viruses {
//            virus.changeVirusMode()
//        }
        
        self.schedule("speedUpViruses", interval: 10)
        
        
    }
    
    
    override func update(delta: CCTime) {
        var randomSpawner = arc4random_uniform(101)
        
        if randomSpawner <= 5 {
            spawnVirus()
//            for virus in viruses {
//                virus.changeVirusMode()
//            }
            
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        for virus in viruses {
            
            var virusWorldSpace = convertToWorldSpace(virus.position)

            if Int(abs(touch.locationInWorld().x - virusWorldSpace.x)) < 50
                && Int(abs(touch.locationInWorld().y - virusWorldSpace.y)) < 50
               /* && virus.mode == .Vulnerable*/{

                viruses.removeAtIndex(find(viruses, virus)!)

                virus.removeFromParent()
                currentScore++
                
            }
            
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, virus: Virus!, computer: CCNode!) -> ObjCBool {
        if isGameOver() {
            triggerGameOver()
        }else if !isGameOver(){
            viruses.removeAtIndex(find(viruses, virus)!)
            virus.removeFromParent()
            load = load + 10
        }
        
        let bool1 : Bool = true
        let myBool = ObjCBool(bool1)
        
        return myBool
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
            virus.scale = 0.018
            gamePhysicsNode.addChild(virus)
        } else if virusType == 1{
            virus = CCBReader.load("Virus2") as! Virus
            virus.scale = 0.018
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

//  Speeds up velocity of viruses by 1
    func speedUpViruses(){
        virusSpeed--
    }
    
//  Sets velocity according to it's spawn position on the screen
    func virusMovementDirection(virus :Virus){
        var x = CGFloat(computer.position.x - virus.position.x) / CGFloat(virusSpeed)
        var y = CGFloat(computer.position.y - virus.position.y) / CGFloat(virusSpeed)
        
        virus.physicsBody.velocity = ccp(x, y)
    }
    
    func triggerGameOver(){
        Singleton.sharedInstance.score = currentScore
        
        let gameOver = CCBReader.loadAsScene("GameOver")
        
        self.unschedule("speedUpViruses")
        
        gameStates = .GameOver
        CCDirector.sharedDirector().replaceScene(gameOver)
        
       
        
    }
    
    func isGameOver() -> Bool{
        if load == 100{
            return true
        }
        return false
    }
    
}