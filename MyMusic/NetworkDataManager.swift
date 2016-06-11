//
//  NetworkDataManager.swift
//  MyMusic
//
//  Created by anoopm on 17/05/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

import UIKit

class NetworkDataManager: NSObject {

    // Singleton instance
    static let sharedNetworkmanager = NetworkDataManager()
    var authenticationToken:String?
    // Create a session
    let session:NSURLSession = {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        return NSURLSession(configuration: config)
    }()
    
    // Method to fetch data from URL
    func fetchDataWithUrl(url:NSURL, completion:(success:Bool,fetchedData:AnyObject)->Void) {
        
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.setValue("Bearer \(self.authenticationToken!)", forHTTPHeaderField: "Authorization")
        print("Bearer \(self.authenticationToken!)")
        let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
            if error != nil{
                print(error?.description)
            }else
            {
                do
                {
                    let jsonObject:AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    completion(success: true, fetchedData: jsonObject)
                }catch
                {
                    
                }
            }
        }
        task.resume()
        
    }
    
    func getAuthenticationTokenWithUrl(url:NSURL, completion:(authToken:String)->Void)
        {
        
            let urlRequest = NSMutableURLRequest(URL: url)
            //urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue(kAppAuthHeader, forHTTPHeaderField: "Authorization")
           // urlRequest.setValue("client_credentials", forHTTPHeaderField: "grant_type")
            urlRequest.HTTPMethod = "POST"
            let grantString = "grant_type=client_credentials"
            //let dictionary = ["grant_type": "client_credentials"]
            //urlRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(dictionary, options: [])
            urlRequest.HTTPBody = grantString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
                if error != nil{
                    print(error?.description)
                }else
                {
                    do
                    {
                        let jsonObject:AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        if let token = jsonObject["access_token"] as? String{
                            self.authenticationToken = token
                            completion(authToken: token)
                            
                        }
                    }catch
                    {
                        
                    }
                }
            }
            task.resume()
    }
}
