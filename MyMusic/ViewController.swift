//
//  ViewController.swift
//  MyMusic
//
//  Created by anoopm on 17/05/16.
//  Copyright © 2016 anoopm. All rights reserved.
//

import UIKit
import MediaPlayer
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    var musicStore:MusicStore!
    // Url for the track
    var trackUrl:String!
    // selected icon path url
    var selectedChannelIconPath:String!
    // selecred channel name
    var selectedChannelName:String!
    // Selected channel
    var selectedChannel:Channel!
    // Get the shared audio player
    let streamPlayer = StreamAudioPlayer.sharedPlayer
    private let cache = NSCache()
    @IBOutlet var channelTableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback,
                                      withOptions: [])
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        self.musicStore = MusicStore(countryCode: "fr")
        self.musicStore.getToken { (success) -> Void in
            if (success){
                self.musicStore.getRadioListForCountryCode("fr", withCompletion: { (success) -> Void in
                    if(success){
                        dispatch_async(dispatch_get_main_queue()){
                            
                            self.channelTableView.reloadData()
                        }
                    }
                })
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func applicationDidBecomeActive(){
        
        self.pause()
    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.musicStore.channelArray.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("channel", forIndexPath: indexPath)
    
        self.configureChannelCell(cell, withData: self.musicStore.channelArray[indexPath.row])
    // Configure the cell...
    
    return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let channel = self.musicStore.channelArray[indexPath.row]
        
        self.musicStore.getRadioStreamsForSlug(channel.slug) { (success) -> Void in
            if(success){
                print("Yeah")
                let stream = self.musicStore.streamArray[0]
                self.trackUrl = stream.url
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Got the stream and now play it
                    self.preparePlayer()
                    // Remember the path of icon url
                    self.selectedChannelIconPath = channel.url_logo_small
                    self.selectedChannelName = channel.name
                    self.selectedChannel = channel
                    self.play()
                    self.setInfoCenter()
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                })

//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.performSegueWithIdentifier("showPlayer", sender: self)
//                })
                
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        
        let destinationVC = segue.destinationViewController as! PlayerVC
        destinationVC.url = self.trackUrl
    }

    /**
     Method to set up the toolbar which shows channel icon as well as player controls
     
     - parameter iconPath, playing status
     
     - returns:void
     */
    func setUpToolbar(withIcon iconPath: String,playingStatus isPlaying: Bool, andWithTitle title:String)
    {
        var toolBarItems = [UIBarButtonItem]()
        
        // Create the icon image in tool bar
        let imageView = UIImageView()
        imageView.frame = CGRectMake(0, 0, 32, 32)
        self.getImageFromPath(iconPath) { (iconImage) in
            if iconImage != nil{
                dispatch_async(dispatch_get_main_queue(), {
                    imageView.image = iconImage
                })
                
            }
        }
        let iconBarButton = UIBarButtonItem(customView: imageView)
        toolBarItems.append(iconBarButton)
        
        // Create a label to display the channel name
        let view = UIView(frame: CGRectMake(0,0,200,30))
        let channelNamelabel = UILabel(frame: view.frame)
        channelNamelabel.text = title
        view.addSubview(channelNamelabel)
        let channelNameBarButton = UIBarButtonItem(customView: view)
        toolBarItems.append(channelNameBarButton)
        
        // Space
        let spaceBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBarItems.append(spaceBarButton)
        
        // If a channel is playing, then show pause button and set action as pause
        if(isPlaying)
        {
            let pauseBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: #selector(pause))
            toolBarItems.append(pauseBarButton)
        }
        // If a channel is not playing, then show play button and set action as play
        else
        {
            let playBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: #selector(play))
            toolBarItems.append(playBarButton)
        }
        self.setToolbarItems(toolBarItems, animated: true)
        self.navigationController?.toolbarHidden = false
    }
    /**
     Method to download an image from url or from cache
     
     - parameter imagePath
     
     - returns:UIImage
     */
    func getImageFromPath(imagePath:String, completion:(iconImage:UIImage?)->Void){
        
        var iconImage:UIImage!
        if let image = cache.objectForKey(imagePath) as? UIImage{
            iconImage = image
            completion(iconImage: image)
        }
        else
        {
            let url = NSURL(string: imagePath)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
                
                let data = NSData(contentsOfURL: url!)
                
                dispatch_async(dispatch_get_main_queue()){
                    
                    if let imageData = data{
                        let image = UIImage(data:imageData)
                        self.cache.setObject(image!, forKey:imagePath)
                        iconImage = image
                        completion(iconImage: image!)
                    }
                    
                }
            }
        }
    }
    
    func configureChannelCell(cell:UITableViewCell, withData channel:Channel){
        
        cell.textLabel?.text = channel.name
        cell.detailTextLabel?.text = channel.baseline
        cell.imageView?.contentMode = .ScaleAspectFill
        if let imagePath = channel.url_logo_small{
            if let image = cache.objectForKey(imagePath) as? UIImage{
                cell.imageView?.image = image
            }
            else
            {
                let url = NSURL(string: imagePath)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
                    
                    let data = NSData(contentsOfURL: url!)
                    
                    dispatch_async(dispatch_get_main_queue()){
                        
                        if let imageData = data{
                            let image = UIImage(data:imageData)
                            self.cache.setObject(image!, forKey:channel.url_logo_small)
                            cell.imageView?.image = image
                        }
                        
                    }
                }
            }
            
        }
        
    }
    
    // MARK: Player controls
    
    func preparePlayer(){
        
        self.streamPlayer.setUpTrackWithUrl(self.trackUrl)
    }
    
    func play(){
        
        self.streamPlayer.play()
        self.setUpToolbar(withIcon: self.selectedChannelIconPath, playingStatus: true, andWithTitle: self.selectedChannelName)
    }
    
    func pause(){
        
        self.streamPlayer.pause()
        self.setUpToolbar(withIcon: self.selectedChannelIconPath, playingStatus: false, andWithTitle: self.selectedChannelName)
    }
    
    func stop(){
        
        self.streamPlayer.stop()
    }
    
    func setInfoCenter(){
        
        if (NSClassFromString("MPNowPlayingInfoCenter") != nil){
            self.getImageFromPath(self.selectedChannel.url_logo_large, completion: { (iconImage) in
                if iconImage != nil{
                    dispatch_async(dispatch_get_main_queue(), {
                        let albumArt = MPMediaItemArtwork(image: iconImage!)
                        let songInfo = [MPMediaItemPropertyTitle:self.selectedChannelName,MPMediaItemPropertyArtwork:albumArt]
                        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = songInfo
                    })
                    
                }
            })

        }
    }
    override func remoteControlReceivedWithEvent(event: UIEvent?) { // *
        if event?.type == .RemoteControl {
            switch event!.subtype {
//            case .RemoteControlTogglePlayPause:
//                if p.playing { p.pause() } else { p.play() }
            case .RemoteControlPlay:
                self.play()
            case .RemoteControlPause:
                self.pause()
            default:break
            }
        }

        
    }


}

