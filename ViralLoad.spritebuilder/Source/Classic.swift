//
//  Classic.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import SpriteKit

class Classic: CCNode {
    
    enum GameStates {
        
        case Title, Playing, GameOver
        
    }
    
    weak var loadPercentage :CCLabelTTF!
    weak var score :CCLabelTTF!
    weak var computer :CCSprite!
    weak var gamePhysicsNode :CCPhysicsNode!
    var viruses :[Virus2] = []
    var bossViruses :[Virus2] = []
    var bombs :[Bomb] = []
    var superBombs :[SuperBomb] = []
    var gameStates :GameStates = .Title
    var virusSpeed :Int = 10
    var virusKillCount :Int = 0
    var bossKillCount :Int = 0
    var randNum :Int = 0
    
    var load :Int = 0{
        didSet{
//            Runs whenever the value of load is changed
            loadPercentage.string = "\(load)"
        }
    }
    
    var currentScore :Int = 0{
        didSet{
//            Runs whenever the value of currentScore is changed
            score.string = "\(currentScore)"
        }
    }
    
//    Called when the CCB file is loaded
    func didLoadFromCCB(){
        //Enables multi touch and user touch
        userInteractionEnabled = true
        multipleTouchEnabled = true
        
        //Tells the game physics node to look for collisions
        gamePhysicsNode.collisionDelegate = self
        
        CCDirector.sharedDirector().resume()
        
        start()
    }
    
//    Called at the start of the game
    func start(){
        gameStates = .Playing
        
        var randomBossSpawner = CCTime(arc4random_uniform(15) + 1)
        self.schedule("spawnBossVirus", interval: randomBossSpawner)
        
        if canSpeedUpViruses() || virusSpeed >= 3{
            self.schedule("speedUpViruses", interval: 10)
            self.schedule("slowDownViruses", interval: 30)
        }else{
            self.unschedule("speedUpViruses")
        }
        
        self.schedule("adjustSpawnRate", interval: 5)
    }
    
//    Called when the pause button is hit
    func pause(){
            CCDirector.sharedDirector().pause()
            Singleton.sharedInstance.mode = "Classic"
        
            let pauseScene = CCBReader.loadAsScene("Pause")
            CCDirector.sharedDirector().pushScene(pauseScene)
    }
    
//    Called every second of gameplay
    override func update(delta: CCTime) {
        var randomSpawner = (Int)(arc4random_uniform(101))
        var noSpawnCount = 0
        var limit = 20
        
        
        if randomSpawner <= randNum && viruses.count < limit{
            spawnVirus()
            limit++
        }
        
        if load >= 100{
            triggerGameOver()
        }
    }
    
//    Called whenever the user interacts with the screen
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        for bomb in bombs{
            var bombWorldSpace = convertToWorldSpace(bomb.position)
            
            if Int(abs(touch.locationInWorld().x - bombWorldSpace.x)) < 30
                && Int(abs(touch.locationInWorld().y - bombWorldSpace.y)) < 30
            {
                bomb.removeFromParent()
                bomb.startExplosion(gamePhysicsNode)
                OALSimpleAudio.sharedInstance().playEffect("Grenade.mp3", loop: false)
                cameraShake(duration: 0.4, shakeX: 2, shakeY: 3)
                bombs.removeAtIndex(find(bombs, bomb)!)
            }
            
        }
        
        for superBomb in superBombs{
            var superBombWorldSpace = convertToWorldSpace(superBomb.position)
            
            if Int(abs(touch.locationInWorld().x - superBombWorldSpace.x)) < 30
                && Int(abs(touch.locationInWorld().y - superBombWorldSpace.y)) < 30
            {
                superBomb.removeFromParent()
                superBomb.startExplosion(gamePhysicsNode)
                OALSimpleAudio.sharedInstance().playEffect("Big Bomb.mp3", loop: false)
                cameraShake(duration: 0.6, shakeX: 2, shakeY: 5)
                superBombs.removeAtIndex(find(superBombs, superBomb)!)
            }
        }
        
        for virus in viruses {
            var virusWorldSpace = convertToWorldSpace(virus.position)
            
            if Int(abs(touch.locationInWorld().x - virusWorldSpace.x)) < 30
                && Int(abs(touch.locationInWorld().y - virusWorldSpace.y)) < 30
                {
                    
                    viruses.removeAtIndex(find(viruses, virus)!)
                    virus.removeFromParent()
                    currentScore++
                    virusKillCount++
                    OALSimpleAudio.sharedInstance().playEffect("explosion.mp3", loop: false)
                    
                    if virusKillCount == 15 {
                        spawnBombAtLoc(virus.position)
                        virusKillCount = 0
                    }
            }
        }
        
        for virus in bossViruses {
            var virusWorldSpace = convertToWorldSpace(virus.position)
            
            if Int(abs(touch.locationInWorld().x - virusWorldSpace.x)) < 30
                && Int(abs(touch.locationInWorld().y - virusWorldSpace.y)) < 30
            {
                virus.tapCount += 1
                
                if (virus.tapCount == 2){
                    bossViruses.removeAtIndex(find(bossViruses, virus)!)
                    virus.removeFromParent()
                    currentScore++
                    bossKillCount++
                    OALSimpleAudio.sharedInstance().playEffect("explosion.mp3", loop: false)
                }
                
                //Super Bomb
                if bossKillCount == 5{
                    spawnSuperBombAtLoc(virus.position)
                    bossKillCount = 0
                }
                
            }
        }
    }
    
    //  Detects collision between the collision types virus & computer
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, virus: Virus2!, computer: CCNode!) -> ObjCBool {
        if isGameOver() {
            triggerGameOver()
        }else if !isGameOver(){
            if (virus.scaleX == 0.018){
                viruses.removeAtIndex(find(viruses, virus)!)
                load = load + 5
            }else if (virus.scaleX == 0.030){
                bossViruses.removeAtIndex(find(bossViruses, virus)!)
                load = load + 10
            }
            virus.removeFromParent()
        }
        
        //  I did this because it was the hackiest way to get the program to load to my device
        let bool1 : Bool = true
        let myBool = ObjCBool(bool1)
        
        return myBool
    }
    
    //  Detects collision between the collision types virus & explosion1
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, virus: Virus2!, explosion1: Explosion1!) -> ObjCBool {
        if find(viruses, virus) != nil && virus != nil{
            viruses.removeAtIndex(find(viruses, virus)!)
        }
        virus.removeFromParent()
        load++
       return true
    }
    
    //  Detects collision between the collision types virus & explosion2
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, virus: Virus2!, explosion2: Explosion2!) -> ObjCBool {
        if find(bossViruses, virus) != nil && virus != nil{
            bossViruses.removeAtIndex(find(bossViruses, virus)!)
        }
        virus.removeFromParent()
        load++
        return true
    }
    
    //  Spawn virus one at a time one of three sides of the screen randomly
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
//        if screenSide == 0{
//            //Top
//            x = UIScreen.mainScreen().bounds.width * CGFloat(percent)
//            y = UIScreen.mainScreen().bounds.height
//            virus.position = CGPoint(x: x, y: y)
//        }else
        if screenSide == 1{
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
    
    //  Spawn a boss virus at a time on either four sides of the screen randomly
    func spawnBossVirus(){
        let virusType = Int(arc4random_uniform(2))
        let screenSide = Int(arc4random_uniform(4))
        let percent = Float(arc4random_uniform(101)) / 100
        var virus :Virus2!
        var x :CGFloat!
        var y :CGFloat!
        
        // Generates random type
        if virusType == 0{
            virus = CCBReader.load("Virus3") as! Virus2
            virus.scale = 0.030
            gamePhysicsNode.addChild(virus)
        } else if virusType == 1{
            virus = CCBReader.load("Virus4") as! Virus2
            virus.scale = 0.030
            gamePhysicsNode.addChild(virus)
        }
        
        // Generates position on either four sides of the screen
//        if screenSide == 0{
//            //Top
//            x = UIScreen.mainScreen().bounds.width * CGFloat(percent)
//            y = UIScreen.mainScreen().bounds.height
//            virus.position = CGPoint(x: x, y: y)
//        }else
            if screenSide == 1{
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
        bossViruses.append(virus)
    }
    
    func spawnBombAtLoc(a :CGPoint){
        var bomb = CCBReader.load("Bomb") as! Bomb
        self.addChild(bomb)
        bomb.scale = 0.15
        bomb.position = a
        bombs.append(bomb)
    }
    
    func spawnSuperBombAtLoc(a :CGPoint){
        var superBomb = CCBReader.load("Super Bomb") as! SuperBomb
        self.addChild(superBomb)
        superBomb.scale = 0.15
        superBomb.position = a
        superBombs.append(superBomb)
    }
    
    //  Speeds up velocity of viruses by 1
    func speedUpViruses(){
        virusSpeed--
    }
    
    //  Slows down viruses by 2
    func slowDownViruses(){
        virusSpeed += 2
    }
    
    //  Checks to see if the viruses speed can be adjusted any further
    func canSpeedUpViruses() ->Bool{
        if virusSpeed <= 0{
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
        self.unschedule("slowDownViruses")
        self.unschedule("adjustSpawnRate")
        
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
    
    func cameraShake(duration a :Double, shakeX x :CGFloat, shakeY y :CGFloat){
        let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: a, position: ccp(x, y)))
        let moveBack = CCActionEaseBounceOut(action: move.reverse())
        let shakeSequence = CCActionSequence(array: [move, moveBack])
        runAction(shakeSequence)
    }
    
    func adjustSpawnRate(){
        var a = (Int)(arc4random_uniform(2) + 1)
        var b = (Int)(arc4random_uniform(4) + 1)
        if a == 0{
            randNum -= b
        }else if a == 1{
            randNum += b
        }
    }
    
}
