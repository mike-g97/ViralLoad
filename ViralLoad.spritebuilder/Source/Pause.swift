//
//  Pause.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Pause: CCNode {
    var highScore :CCLabelTTF!
    
//    Called when the CCB file is loaded
    func didLoadFromCCB(){
        if Singleton.sharedInstance.mode == "Classic" {
            if Singleton.sharedInstance.classicHighScore == nil{
                highScore.string = "\(0)"
            }else{
                highScore.string = "\(Singleton.sharedInstance.classicHighScore)"
            }
        }else if Singleton.sharedInstance.mode == "Insanity" {
            if Singleton.sharedInstance.insanityHighScore == nil{
                highScore.string = "\(0)"
            }else{
                highScore.string = "\(Singleton.sharedInstance.insanityHighScore)"
            }
        }
    }
    
//    Called when the resume button is hit
    func resume(){
        CCDirector.sharedDirector().popScene()
        CCDirector.sharedDirector().resume()
    }
    
//    Called when the quit button is hit
    func loadHome(){
        let homeScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(homeScene)
    }
    
//    Called when the restart button is hit
    func restart(){
        let gameplayScene = CCBReader.loadAsScene("\(Singleton.sharedInstance.mode)")
        CCDirector.sharedDirector().replaceScene(gameplayScene)
    }
}

