//
//  ViewHighScore.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class ViewHighScore: CCNode {
    weak var classicHighScoreLabel :CCLabelTTF!
    weak var insanityHighScoreLabel :CCLabelTTF!
    let defaults = NSUserDefaults.standardUserDefaults()
    var classicHighscore :Int!
    var insanityHighscore :Int!
    
    func didLoadFromCCB(){
        // Checks for classic mode highscore sees if its nil and sets it to zero and saves it in defaults
        if Singleton.sharedInstance.classicHighScore == nil{
            defaults.setInteger(0, forKey: "classicHighScore")
        }else{
            defaults.setInteger(Singleton.sharedInstance.classicHighScore, forKey: "classicHighScore")
        }
        classicHighscore = defaults.integerForKey("classicHighScore")
        classicHighScoreLabel.string = "\(classicHighscore)"
        
        // Checks for insanity mode highscore sees if its nil and sets it to zero and saves it in defaults
        if Singleton.sharedInstance.insanityHighScore == nil{
            defaults.setInteger(0, forKey: "insanityHighScore")
        }else{
            defaults.setInteger(Singleton.sharedInstance.insanityHighScore, forKey: "insanityHighScore")
        }
        
        insanityHighscore = defaults.integerForKey("insanityHighScore")
        insanityHighScoreLabel.string = "\(insanityHighscore)"

    }
    
    func loadHome(){
        let homeScreen = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(homeScreen)
    }
}
