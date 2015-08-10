//
//  GameModes.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class GameModes: CCNode {
   
//    Called when the classic button is hit
    func playClassic(){
        let classicScene = CCBReader.loadAsScene("Classic")
        CCDirector.sharedDirector().replaceScene(classicScene)
        Mixpanel.sharedInstance().track("Picked Classic Mode")
    }
    
//    Called when the insanity button is hit
    func playInsanity(){
        let insanityScene = CCBReader.loadAsScene("Insanity")
        CCDirector.sharedDirector().replaceScene(insanityScene)
        Mixpanel.sharedInstance().track("Picked Insanity Mode")
    }
}
