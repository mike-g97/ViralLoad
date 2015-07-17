//
//  ClassicGameOver.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class ClassicGameOver: CCNode {
    let defaults = NSUserDefaults.standardUserDefaults()
    weak var gameOverHighScore :CCLabelTTF!
    weak var gameOverScore :CCLabelTTF!
    var score :Int!
    
    func  didLoadFromCCB(){
        self.position = ccp(CCDirector.sharedDirector().viewSize().width/2, CCDirector.sharedDirector().viewSize().height/4)
        
        score = Singleton.sharedInstance.classicScore
        gameOverScore.string = "\(score)"
        
        
        var highScore = defaults.integerForKey("highScore")
        gameOverHighScore.string = "\(highScore)"
        
        if highScore < score{
            defaults.setInteger(score, forKey: "highScore")
            gameOverHighScore.string = "\(score)"
        }
        
        Singleton.sharedInstance.classicHighScore = defaults.integerForKey("highScore")
//        println("\(Singleton.sharedInstance.classicHighScore)")
        
    }
    
    func restart(){
        let classicScene = CCBReader.loadAsScene("Classic")
        CCDirector.sharedDirector().replaceScene(classicScene)
    }
    
    func loadHome(){
        let homeScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(homeScene)
    }

}
