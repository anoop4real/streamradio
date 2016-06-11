//
//  MusicStore.swift
//  MyMusic
//
//  Created by anoopm on 18/05/16.
//  Copyright © 2016 anoopm. All rights reserved.
//


import UIKit
/*!
Class which manages all the data model objects and initiates network calls
*/
class MusicStore: NSObject {

    var countryCode:String!
    var channelArray = [Channel]()
    var streamArray  = [Stream]()

    init(countryCode:String) {
        
        self.countryCode = countryCode
    }
    
    func getToken(withCompletion completion:(success:Bool)->Void){
        
        let urlString:String = "https://api.orange.com/oauth/v2/token"
        let url = NSURL(string: urlString)!
        let networkManager = NetworkDataManager.sharedNetworkmanager
        
        networkManager.getAuthenticationTokenWithUrl(url) { (authToken) -> Void in
            print(authToken)
            
            completion(success: true)
        }
        //https://api.orange.com/orangeradio/v1/selections/fr/radios?offset=0&limit=20
    }
    
    func getRadioListForCountryCode(countryCode:String, withCompletion completion:(success:Bool)->Void){
        
        let urlString:String = "https://api.orange.com/orangeradio/v1/selections/\(countryCode)/radios?offset=0&limit=20"
        let url = NSURL(string: urlString)!
        let networkManager = NetworkDataManager.sharedNetworkmanager
        networkManager.fetchDataWithUrl(url) { (success, fetchedData) -> Void in
            
            if let channelData = fetchedData as? Array<AnyObject>{
                
                for channelDict in channelData{
                    
                    let channel = Channel(channelDataDictionary: channelDict as! Dictionary<String, AnyObject>)
                    self.channelArray.append(channel)
                }
                completion(success: true)
                
            }
            print(fetchedData)
        }
    }
    
    func getRadioStreamsForSlug(slug:String, withCompletion completion:(success:Bool)->Void){
        
        let urlString:String = "https://api.orange.com/orangeradio/v1/radios/\(slug)/streams"
        let url = NSURL(string: urlString)!
        let networkManager = NetworkDataManager.sharedNetworkmanager
        networkManager.fetchDataWithUrl(url) { (success, fetchedData) -> Void in
            
            if let streamData = fetchedData as? Array<AnyObject>{
                
                for streamDict in streamData{
                    
                    let stream = Stream(streamDict: streamDict as! Dictionary<String, AnyObject>)
                    self.streamArray.append(stream)
                }
                completion(success: true)
                
            }
            print(fetchedData)
        }
    }
}
