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
        
    
//  CallBack between invulnerable to vulnerable
    func invulnerable(){
        if mode == .Invulnerable{
            mode = .Vulnerable
        } else{
            mode = .Invulnerable
        }
    }
    
//  CallBack between vulnerable to invulnerable
}
