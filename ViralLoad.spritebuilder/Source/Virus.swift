//
//  Virus.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Virus: CCSprite {
    
    enum virusMode {
        case Invulnerable, Vulnerable
    }

    var mode :virusMode = .Invulnerable
    
    //  Changes virus mode randomly by switching between timelines
    func changeVirusMode(){
        let num = arc4random_uniform(101)
        
        if num <= 10{
            self.animationManager.runAnimationsForSequenceNamed("Vulnerable Mode")
            mode = .Vulnerable
        }else{
            self.animationManager.runAnimationsForSequenceNamed("Default Timeline")
            mode = .Invulnerable
        }
    }
    
}
