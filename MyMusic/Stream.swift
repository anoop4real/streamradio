//
//  Stream.swift
//  MyMusic
//
//  Created by anoopm on 18/05/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

import Foundation

struct Stream {
    var url:String!
    
    init(streamDict:Dictionary<String,AnyObject>){
        
        if let url = streamDict["url"] as? String{
            self.url = url
        }
    }
}