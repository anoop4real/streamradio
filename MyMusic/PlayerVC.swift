//
//  PlayerVC.swift
//  MyMusic
//
//  Created by anoopm on 18/05/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

import UIKit

class PlayerVC: UIViewController {

    var url:String!
    let streamPlayer = StreamAudioPlayer.sharedPlayer
    override func viewDidLoad() {
        self.preparePlayer()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func preparePlayer(){
        
        self.streamPlayer.setUpTrackWithUrl(self.url)
    }
    
    @IBAction func play(){
    
        self.streamPlayer.play()
    }
    
    @IBAction func pause(){
        
        self.streamPlayer.pause()
    }
    
    @IBAction func stop(){
        
        self.streamPlayer.stop()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
