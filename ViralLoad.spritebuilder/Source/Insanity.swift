//
//  Insanity.swift
//  ViralLoad
//  Made with <3 by Mike
//  Created by Mikhael Gonzalez on 7/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
import Foundation

class Insanity: CCNode, CCPhysicsCollisionDelegate {

    enum GameStates {
        
        case Title, Playing, GameOver
        
    }
    
    weak var loadPercentage :CCLabelTTF!
    weak var score :CCLabelTTF!
    weak var infoLabel :CCLabelTTF!
    weak var computer :CCSprite!
    weak var infoButton :CCButton!
    weak var gamePhysicsNode :CCPhysicsNode!
    var viruses :[Virus] = []
    var gameStates :GameStates = .Title
    var virusSpeed :Int = 20
    

    var load :Int = 0{
        didSet{
//            Runs whenever the value of load is changed
            loadPercentage.string = "\(load)"
        }
    }
    
    var currentScore :Int = 0{
        didSet{
//           Runs whenever the value of currentScore is changed
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
    
//    Tutorial caption
    func info(){
        self.infoLabel.removeFromParent()
        self.infoButton.removeFromParent()
    }
    
//    Called at the start of the game
    func start(){
        gameStates = .Playing
        
        if canSpeedUpViruses(){
            self.schedule("speedUpViruses", interval: 20)
        }else{
            self.unschedule("speedUpViruses")
        }
    }
    
//    Called when the pause button is hit
    func pause(){
            CCDirector.sharedDirector().pause()
            Singleton.sharedInstance.mode = "Insanity"
            
            let pauseScene = CCBReader.loadAsScene("Pause")
            CCDirector.sharedDirector().pushScene(pauseScene)
    }
    
//    Called every second of gameplays
    override func update(delta: CCTime) {
        let randomSpawner = arc4random_uniform(101)
        let numOfVirusesSpawned = viruses.count
        var limit = 10
        
        if randomSpawner <= 5 && numOfVirusesSpawned < limit{
            spawnVirus()
            limit++
        }
        
        if load >= 100{
            triggerGameOver()
        }
    }
    
//    Called whenever the user interacts with the screen
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        for virus in viruses {
            let virusWorldSpace = convertToWorldSpace(virus.position)
 
            if Int(abs(touch.locationInWorld().x - virusWorldSpace.x)) < 30
                && Int(abs(touch.locationInWorld().y - virusWorldSpace.y)) < 30
                && virus.mode == .Vulnerable{
                    
                    viruses.removeAtIndex(viruses.indexOf(virus)!)
                    virus.removeFromParent()
                    currentScore++
                    OALSimpleAudio.sharedInstance().playEffect("explosion.mp3", loop: false)
                    
            } else if Int(abs(touch.locationInWorld().x - virusWorldSpace.x)) < 20
                && Int(abs(touch.locationInWorld().y - virusWorldSpace.y)) < 20
                && virus.mode == .Invulnerable{
        
                        load = load + 6
            }
        }
    }
    
    //  Detects collision between the collision types virus & computer
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, virus: Virus!, computer: CCNode!) -> ObjCBool {
        if isGameOver() {
            triggerGameOver()
        }else if !isGameOver(){
            viruses.removeAtIndex(viruses.indexOf(virus)!)
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
        var virus :Virus!
        var x :CGFloat!
        var y :CGFloat!
     
        // Generates random type
        if virusType == 0{
            virus = CCBReader.load("Virus1") as! Virus
            virus.scale = 0.018
            gamePhysicsNode.addChild(virus)
        } else if virusType == 1{
            virus = CCBReader.load("Virus2") as! Virus
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
    func virusMovementDirection(virus :Virus){
        let x = CGFloat(computer.position.x - virus.position.x) / CGFloat(virusSpeed)
        let y = CGFloat(computer.position.y - virus.position.y) / CGFloat(virusSpeed)
 
        virus.physicsBody.velocity = ccp(x, y)
    }
    
    //  Triggers once load reaches 100
    func triggerGameOver(){
        Singleton.sharedInstance.insanityScore = currentScore
        let insanityGameOver = CCBReader.loadAsScene("InsanityGameOver")
        
        self.unschedule("speedUpViruses")
        
        gameStates = .GameOver
        
        CCDirector.sharedDirector().replaceScene(insanityGameOver)
    }
    
    //  Checks to see if game is over
    func isGameOver() -> Bool{
        if load >= 100{
            return true
        }
        return false
    }
 
}