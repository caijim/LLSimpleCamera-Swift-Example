//
//  CameraViewController.swift
//  LLSimpleCamera-Swift-Example
//
//  Created by StrawBerry on 20.01.2016.
//  Copyright © 2016 StrawBerry. All rights reserved.
//

import UIKit
import LLSimpleCamera

class ViewController: UIViewController {
    
    var errorLabel = UILabel();
    var snapButton = UIButton();
    var switchButton = UIButton();
    var flashButton = UIButton()
    var settingsButton = UIButton();
    var segmentedControl = UISegmentedControl();
    var camera = LLSimpleCamera();
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.camera.start();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        self.view.backgroundColor = UIColor.blackColor();
        
        let screenRect = UIScreen.mainScreen().bounds;
        
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionFront, videoEnabled: true)
        self.camera.attachToViewController(self, withFrame: CGRectMake(0, 0, screenRect.size.width, screenRect.size.height))
        self.camera.fixOrientationAfterCapture = true;
        

        self.camera.onDeviceChange = {(camera, device) -> Void in
            if camera.isFlashAvailable() {
                self.flashButton.hidden = false
                if camera.flash == LLCameraFlashOff {
                    self.flashButton.selected = false
                }
                else {
                    self.flashButton.selected = true
                }
            }
            else {
                self.flashButton.hidden = true
            }
        }
        
        self.camera.onError = {(camera, error) -> Void in
            if (error.domain == LLSimpleCameraErrorDomain) {
                if error.code == 10 || error.code == 11 {
                    if(self.view.subviews.contains(self.errorLabel)){
                        self.errorLabel.removeFromSuperview()
                    }
                    
                    let label: UILabel = UILabel(frame: CGRectZero)
                    label.text = "We need permission for the camera and microphone."
                    label.numberOfLines = 2
                    label.lineBreakMode = .ByWordWrapping;
                    label.backgroundColor = UIColor.clearColor()
                    label.font = UIFont(name: "AvenirNext-DemiBold", size: 13.0)
                    label.textColor = UIColor.whiteColor()
                    label.textAlignment = .Center
                    label.sizeToFit()
                    label.center = CGPointMake(screenRect.size.width / 2.0, screenRect.size.height / 2.0)
                    self.errorLabel = label
                    self.view!.addSubview(self.errorLabel)
                    
                    let jumpSettingsBtn: UIButton = UIButton(frame: CGRectMake(50, label.frame.origin.y + 50, screenRect.size.width - 100, 50));
                    jumpSettingsBtn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 24.0)
                    jumpSettingsBtn.setTitle("Go Settings", forState: .Normal);
                    jumpSettingsBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal);
                    jumpSettingsBtn.layer.borderColor = UIColor.whiteColor().CGColor;
                    jumpSettingsBtn.layer.cornerRadius = 5;
                    jumpSettingsBtn.layer.borderWidth = 2;
                    jumpSettingsBtn.clipsToBounds = true;
                    jumpSettingsBtn.addTarget(self, action: "jumpSettinsButtonPressed:", forControlEvents: .TouchUpInside);
                    jumpSettingsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
                    
                    self.settingsButton = jumpSettingsBtn;
                    
                    self.view!.addSubview(self.settingsButton);
                    
                    self.switchButton.enabled = false;
                    self.flashButton.enabled = false;
                    self.snapButton.enabled = false;
                }
            }
        }
        
        if(LLSimpleCamera.isFrontCameraAvailable() && LLSimpleCamera.isRearCameraAvailable()){
            self.snapButton = UIButton(type: .Custom)
            self.snapButton.frame = CGRectMake(0, 0, 70.0, 70.0)
            self.snapButton.clipsToBounds = true
            self.snapButton.layer.cornerRadius = self.snapButton.frame.width / 2.0
            self.snapButton.layer.borderColor = UIColor.whiteColor().CGColor
            self.snapButton.layer.borderWidth = 3.0
            self.snapButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6);
            self.snapButton.layer.rasterizationScale = UIScreen.mainScreen().scale
            self.snapButton.layer.shouldRasterize = true
            self.snapButton.addTarget(self, action: "snapButtonPressed:", forControlEvents: .TouchUpInside)
            self.view!.addSubview(self.snapButton)
            
            self.flashButton = UIButton(type: .System)
            self.flashButton.frame = CGRectMake(0, 0, 16.0 + 20.0, 24.0 + 20.0)
            self.flashButton.tintColor = UIColor.whiteColor()
            self.flashButton.setImage(UIImage(named: "camera-flash.png"), forState: .Normal)
            self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            self.flashButton.addTarget(self, action: "flashButtonPressed:", forControlEvents: .TouchUpInside)
            self.flashButton.hidden = true;
            self.view!.addSubview(self.flashButton)
            
            self.switchButton = UIButton(type: .System)
            self.switchButton.frame = CGRectMake(0, 0, 29.0 + 20.0, 22.0 + 20.0)
            self.switchButton.tintColor = UIColor.whiteColor()
            self.switchButton.setImage(UIImage(named: "camera-switch.png"), forState: .Normal)
            self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            self.switchButton.addTarget(self, action: "switchButtonPressed:", forControlEvents: .TouchUpInside)
            self.view!.addSubview(self.switchButton)
            
            self.segmentedControl = UISegmentedControl(items: ["Picture", "Video"])
            self.segmentedControl.frame = CGRectMake(12.0, screenRect.size.height - 60, 120.0, 32.0)
            self.segmentedControl.selectedSegmentIndex = 0
            self.segmentedControl.tintColor = UIColor.whiteColor()
            self.segmentedControl.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents: .ValueChanged)
            self.view!.addSubview(self.segmentedControl)
        }
        else{
            let label: UILabel = UILabel(frame: CGRectZero)
            label.text = "You must have a camera to take video."
            label.numberOfLines = 2
            label.lineBreakMode = .ByWordWrapping;
            label.backgroundColor = UIColor.clearColor()
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 13.0)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.sizeToFit()
            label.center = CGPointMake(screenRect.size.width / 2.0, screenRect.size.height / 2.0)
            self.errorLabel = label
            self.view!.addSubview(self.errorLabel)
        }
    }
    
    func segmentedControlValueChanged(control: UISegmentedControl) {
        print("Segment value changed!")
    }
    
    func cancelButtonPressed(button: UIButton) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func jumpSettinsButtonPressed(button: UIButton){
        UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!);
    }
    
    func switchButtonPressed(button: UIButton) {
        if(camera.position == LLCameraPositionRear){
            self.flashButton.hidden = false;
        }
        else{
            self.flashButton.hidden = true;
        }
        
        self.camera.togglePosition()
    }
    
    func snapButtonPressed(button: UIButton) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            // capture
            self.camera.capture({(camera, image, metadata, error) -> Void in
                if (error == nil) {
                    camera.performSelector("stop", withObject: nil, afterDelay: 0.2)
                    let imageVC: PreviewImageViewController = PreviewImageViewController(image: image)
                    self.presentViewController(imageVC, animated: false, completion: { _ in })
                }
                else {
                    print("An error has occured: %@", error)
                }
            }, exactSeenImage: true)
        }
        else{
            if(!camera.recording) {
                if(self.camera.position == LLCameraPositionRear && !self.flashButton.hidden){
                    self.flashButton.hidden = true;
                }
                self.segmentedControl.hidden = true
                self.switchButton.hidden = true
                self.snapButton.layer.borderColor = UIColor.redColor().CGColor
                self.snapButton.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5);
                // start recording
                let outputURL: NSURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("test1").URLByAppendingPathExtension("mov")
                self.camera.startRecordingWithOutputUrl(outputURL)
            }
            else{
                if(self.camera.position == LLCameraPositionRear && self.flashButton.hidden){
                    self.flashButton.hidden = false;
                }
                self.segmentedControl.hidden = false;
                self.switchButton.hidden = false
                self.snapButton.layer.borderColor = UIColor.whiteColor().CGColor
                self.snapButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5);
                self.camera.stopRecording({(camera, outputFileUrl, error) -> Void in
                    let vc: PreviewVideoViewController = PreviewVideoViewController(videoUrl: outputFileUrl)
                    self.navigationController!.pushViewController(vc, animated: true)
                })
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.camera.view.frame = self.view.bounds
        self.snapButton.center = self.view.center
        self.snapButton.frame.origin.y = self.view.bounds.height - 90
        self.flashButton.center = self.view.center
        self.flashButton.frame.origin.y = 5.0
        self.switchButton.frame.origin.y = 5.0
        self.switchButton.frame.origin.x = self.view.frame.width - 60.0
    }
    
    func flashButtonPressed(button: UIButton) {
        if self.camera.flash == LLCameraFlashOff {
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOn)
            if done {
                self.flashButton.selected = true
                self.flashButton.tintColor = UIColor.yellowColor();
            }
        }
        else {
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOff)
            if done {
                self.flashButton.selected = false
                self.flashButton.tintColor = UIColor.whiteColor();
            }
        }
    }
    
    func applicationDocumentsDirectory()-> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
}
