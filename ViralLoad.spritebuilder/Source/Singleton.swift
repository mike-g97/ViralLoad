//
//  Singleton.swift
//  ViralLoad
//
//  Created by Mikhael Gonzalez on 7/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//


class Singleton: NSObject {
   static let sharedInstance = Singleton()
    var insanityScore :Int!
    var classicScore :Int!
    var insanityHighScore :Int!
    var classicHighScore :Int!
    
    private override init(){}
}


