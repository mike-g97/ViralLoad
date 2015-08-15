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
    var score :Int = 0
    
//    Called whenever the CCB file is loaded
    func  didLoadFromCCB(){
        self.position = ccp(CCDirector.sharedDirector().viewSize().width * 0.46, CCDirector.sharedDirector().viewSize().height * 0.25)
        
        score = Singleton.sharedInstance.insanityScore
        gameOverScore.string = "\(score)"
        
        
        var highScore = defaults.integerForKey("insanityHighScore")
        gameOverHighScore.string = "\(highScore)"
        
        if highScore < score{
            defaults.setInteger(score, forKey: "insanityHighScore")
            defaults.synchronize()
            gameOverHighScore.string = "\(score)"
            GameCenterInteractor.sharedInstance.saveHighScore("Insanity", score: score)
        }
        
        Singleton.sharedInstance.insanityHighScore = defaults.integerForKey("insanityHighScore")
        Mixpanel.sharedInstance().registerSuperProperties(["Insanity High Score" : gameOverHighScore.string])
    }
    
    
//    Called when the restart button is hit
    func restart(){
        let insanityScene = CCBReader.loadAsScene("Insanity")
        CCDirector.sharedDirector().replaceScene(insanityScene)
    }
    
//    Called whenever the quit button is hit
    func loadHome(){
        let homeScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(homeScene)
    }
}
