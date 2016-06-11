//
//  StreamAudioPlayer.swift
//  MyMusic
//
//  Created by anoopm on 18/05/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

import UIKit
import AVFoundation

class StreamAudioPlayer: NSObject {

    static let sharedPlayer = StreamAudioPlayer()
    var player:AVPlayer!
    var url:NSURL!
    
    func setUpTrackWithUrl(url:String)
    {
        self.url = NSURL(string: url)!
        if (player != nil) {
            player = nil
        }
            let mediaItem = AVPlayerItem(URL: self.url)
            player = AVPlayer(playerItem: mediaItem)


    }
    func initializeAudioSession()
    {
        
    }
    func play() {

        player!.play()
    }
    
    func stop(){

            player.rate = 0.0
    }
    
    func pause(){

            player!.pause()
    }

}
