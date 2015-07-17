//
//  Classic.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Classic: CCNode {
    
    enum GameStates {
        
        case Title, Playing, GameOver
        
    }
    
    weak var loadPercentage :CCLabelTTF!
    weak var score :CCLabelTTF!
    weak var computer :CCSprite!
    weak var gamePhysicsNode :CCPhysicsNode!
    var viruses :[Virus2] = []
    var gameStates :GameStates = .Title
    var virusSpeed :Int = 5
    
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
        
        if canSpeedUpViruses(){
            self.schedule("speedUpViruses", interval: 20)
        }else{
            self.unschedule("speedUpViruses")
        }
    }
    
    override func update(delta: CCTime) {
        var randomSpawner = arc4random_uniform(101)
        var numOfVirusesSpawned = viruses.count
        var limit = 10
        
        if randomSpawner <= 5 && numOfVirusesSpawned < limit{
            spawnVirus()
            limit++
        }
        
        if load >= 100{
            triggerGameOver()
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        for virus in viruses {
            var virusWorldSpace = convertToWorldSpace(virus.position)
            
            if Int(abs(touch.locationInWorld().x - virusWorldSpace.x)) < 20
                && Int(abs(touch.locationInWorld().y - virusWorldSpace.y)) < 20
                {
                    
                    viruses.removeAtIndex(find(viruses, virus)!)
                    virus.removeFromParent()
                    currentScore++
            }
        }
    }
    
    //  Detects collision between the collision types virus & computer
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, virus: Virus2!, computer: CCNode!) -> ObjCBool {
        if isGameOver() {
            triggerGameOver()
        }else if !isGameOver(){
            viruses.removeAtIndex(find(viruses, virus)!)
            virus.removeFromParent()
            load = load + 5
        }
        
        //  I did this because it was the hackiest way to get the program to load to my device
        let bool1 : Bool = true
        let myBool = ObjCBool(bool1)
        
        return myBool
    }
    
    
    
    //  Spawn virus at a time on either four sides of the screen randomly
    func spawnVirus(){
        let virusType = Int(arc4random_uniform(2))
        let screenSide = Int(arc4random_uniform(4))
        let percent = Float(arc4random_uniform(101)) / 100
        var virus :Virus2!
        var x :CGFloat!
        var y :CGFloat!
        
        // Generates random type
        if virusType == 0{
            virus = CCBReader.load("Virus3") as! Virus2
            virus.scale = 0.018
            gamePhysicsNode.addChild(virus)
        } else if virusType == 1{
            virus = CCBReader.load("Virus4") as! Virus2
            virus.scale = 0.018
            gamePhysicsNode.addChild(virus)
        }
        
        // Generates position on either four sides of the screen
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
    
    //  Checks to see if the viruses speed can be adjusted any further
    func canSpeedUpViruses() ->Bool{
        if virusSpeed == 1{
            return false
        }
        return true
    }
    
    //  Sets velocity according to it's spawn position on the screen
    func virusMovementDirection(virus :Virus2){
        var x = CGFloat(computer.position.x - virus.position.x) / CGFloat(virusSpeed)
        var y = CGFloat(computer.position.y - virus.position.y) / CGFloat(virusSpeed)
        
        virus.physicsBody.velocity = ccp(x, y)
    }
    
    //  Triggers once load reaches 100
    func triggerGameOver(){
        Singleton.sharedInstance.classicScore = currentScore
        let classicGameOver = CCBReader.loadAsScene("ClassicGameOver")
        
        self.unschedule("speedUpViruses")
        
        gameStates = .GameOver
        
        CCDirector.sharedDirector().replaceScene(classicGameOver)
    }
    
    //  Checks to see if game is over
    func isGameOver() -> Bool{
        if load >= 100{
            return true
        }
        return false
    }
    
}
