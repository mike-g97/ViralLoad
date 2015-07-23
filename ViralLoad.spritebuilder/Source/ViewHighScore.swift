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
        
        if Singleton.sharedInstance.classicHighScore == nil{
            classicHighscore = 0
        }else{
            classicHighscore = Singleton.sharedInstance.classicHighScore
        }
        
        classicHighScoreLabel.string = "\(classicHighscore)"
        
        if Singleton.sharedInstance.insanityHighScore == nil{
            insanityHighscore = 0
        }else{
            insanityHighscore = Singleton.sharedInstance.insanityHighScore
        }
        
        insanityHighScoreLabel.string = "\(insanityHighscore)"
    }
    
    func loadHome(){
        let homeScreen = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(homeScreen)
    }
}
