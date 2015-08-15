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
    var score :Int = 0
    
//    Called when the CCB file is loaded
    func  didLoadFromCCB(){
        self.position = ccp(CCDirector.sharedDirector().viewSize().width * 0.46, CCDirector.sharedDirector().viewSize().height * 0.25)
        
        score = Singleton.sharedInstance.classicScore
        gameOverScore.string = "\(score)"
        
        
        var highScore = defaults.integerForKey("classicHighScore")
        gameOverHighScore.string = "\(highScore)"
        
        if highScore < score{
            defaults.setInteger(score, forKey: "classicHighScore")
            defaults.synchronize()
            gameOverHighScore.string = "\(score)"
            GameCenterInteractor.sharedInstance.saveHighScore("Classic", score: score)
        }
        
        Singleton.sharedInstance.classicHighScore = defaults.integerForKey("classicHighScore")
        Mixpanel.sharedInstance().registerSuperProperties(["Classic High Score" : gameOverHighScore.string])
    }
    
//    Called when the restart button is hit
    func restart(){
        let classicScene = CCBReader.loadAsScene("Classic")
        CCDirector.sharedDirector().replaceScene(classicScene)
    }
    
//    Called when the quit button is hit
    func loadHome(){
        let homeScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(homeScene)
    }

}
