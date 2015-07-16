//
//  GameOver.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class GameOver: CCNode {
    let defaults = NSUserDefaults.standardUserDefaults()
    weak var gameOverHighScore :CCLabelTTF!
    weak var gameOverScore :CCLabelTTF!
    var score :Int!
    
    func  didLoadFromCCB(){
        self.position = ccp(CCDirector.sharedDirector().viewSize().width/2, CCDirector.sharedDirector().viewSize().height/4)
        
        score = Singleton.sharedInstance.score
        gameOverScore.string = "\(score)"
        
        
        var highScore = defaults.integerForKey("highScore")
        gameOverHighScore.string = "\(highScore)"
        
        if highScore < score{
            defaults.setInteger(score, forKey: "highScore")
            gameOverHighScore.string = "\(score)"
        }
        
    }
    
    func restart(){
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().replaceScene(gameplayScene)
    }
}
