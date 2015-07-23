//
//  InsanityGameOver.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class InsanityGameOver: CCNode {
    let defaults = NSUserDefaults.standardUserDefaults()
    weak var gameOverHighScore :CCLabelTTF!
    weak var gameOverScore :CCLabelTTF!
    var score :Int!
    
    func  didLoadFromCCB(){
        self.position = ccp(CCDirector.sharedDirector().viewSize().width/2, CCDirector.sharedDirector().viewSize().height/4)
        
        score = Singleton.sharedInstance.insanityScore
        gameOverScore.string = "\(score)"
        
        
        var highScore = defaults.integerForKey("insanityHighScore")
        gameOverHighScore.string = "\(highScore)"
        
        if highScore < score{
            defaults.setInteger(score, forKey: "insanityHighScore")
            defaults.synchronize()
            gameOverHighScore.string = "\(score)"
        }
        
        Singleton.sharedInstance.insanityHighScore = defaults.integerForKey("insanityHighScore")
    }
    
    func restart(){
        let insanityScene = CCBReader.loadAsScene("Insanity")
        CCDirector.sharedDirector().replaceScene(insanityScene)
    }
    
    func loadHome(){
        let homeScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(homeScene)
    }
}
