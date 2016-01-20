//
//  PreviewVideoViewController.swift
//  LLSimpleCamera-Swift-Example
//
//  Created by StrawBerry on 20.01.2016.
//  Copyright © 2016 StrawBerry. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewVideoViewController: UIViewController {
    
    var videoUrl = NSURL();
    var avPlayer = AVPlayer();
    var avPlayerLayer = AVPlayerLayer();
    var backButton = UIButton();
    
    convenience init(videoUrl url: NSURL) {
        self.init()
        self.videoUrl = url
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.avPlayer.play();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        // the video player
        let item = AVPlayerItem(URL: self.videoUrl);
        self.avPlayer = AVPlayer(playerItem: item);
        self.avPlayer.actionAtItemEnd = .None
        self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.avPlayer.currentItem!)
        
        let screenRect: CGRect = UIScreen.mainScreen().bounds
        
        self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)
        self.view.layer.addSublayer(self.avPlayerLayer)
        
        self.backButton.addTarget(self, action: "backButtonPressed:", forControlEvents: .TouchUpInside)
        self.backButton.frame = CGRectMake(7, 13, 65, 30)
        self.backButton.layer.borderColor = UIColor.whiteColor().CGColor;
        self.backButton.layer.borderWidth = 2;
        self.backButton.layer.cornerRadius = 5;
        self.backButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 13);
        self.backButton.setTitle("Back", forState: .Normal)
        self.backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        self.backButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.backButton.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.backButton.layer.shadowOpacity = 0.4
        self.backButton.layer.shadowRadius = 1.0
        self.backButton.clipsToBounds = false
        
        self.view!.addSubview(self.backButton)
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        self.avPlayer.seekToTime(kCMTimeZero);
    }
    
    func backButtonPressed(button: UIButton) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
