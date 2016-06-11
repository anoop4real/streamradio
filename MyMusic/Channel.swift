//
//  Channel.swift
//  MyMusic
//
//  Created by anoopm on 18/05/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

import Foundation
import UIKit

struct Channel {
    
    var name:String!
    var baseline:String!
    var slug:String!
    var url_logo:String!
    var url_logo_large:String!
    var url_logo_small:String!
    var url_logo_medium:String!
    var url_logo_small_image:UIImage!
    
    init(channelDataDictionary:Dictionary<String, AnyObject>){
        
        // Name of channel
        if let name = channelDataDictionary["name"] as? String
        {
            self.name = name
        }
        // Subtitle/ Moto
        if let baseline = channelDataDictionary["baseline"] as? String
        {
            self.baseline = baseline
        }
        // Used for fetching streams and podcasts
        if let slug = channelDataDictionary["slug"] as? String
        {
            self.slug = slug
        }
        if let url_logo = channelDataDictionary["url_logo"] as? String
        {
            self.url_logo = url_logo
        }
        if let url_logo_large = channelDataDictionary["url_logo_large"] as? String
        {
            self.url_logo_large = url_logo_large
        }
        if let url_logo_small = channelDataDictionary["url_logo_small"] as? String
        {
            self.url_logo_small = url_logo_small
        }
        if let url_logo_medium = channelDataDictionary["url_logo_medium"] as? String
        {
            self.url_logo_medium = url_logo_medium
        }
    }
    
}