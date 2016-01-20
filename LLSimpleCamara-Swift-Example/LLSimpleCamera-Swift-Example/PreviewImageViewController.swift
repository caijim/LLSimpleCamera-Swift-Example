//
//  PreviewImageViewController.swift
//  LLSimpleCamera-Swift-Example
//
//  Created by StrawBerry on 20.01.2016.
//  Copyright © 2016 StrawBerry. All rights reserved.
//

import UIKit

class PreviewImageViewController: UIViewController {
    
    var image = UIImage();
    var imageView = UIImageView();
    var infoLabel = UILabel();
    var cancelButton = UIButton();

    convenience init(image: UIImage) {
        self.init(nibName: nil, bundle: nil)
        self.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        self.imageView.backgroundColor = UIColor.blackColor()
        let screenRect: CGRect = UIScreen.mainScreen().bounds
        self.imageView = UIImageView(frame: CGRectMake(0, 0, screenRect.size.width, screenRect.size.height))
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.backgroundColor = UIColor.clearColor()
        self.imageView.image = self.image
        self.view!.addSubview(self.imageView)

        let info: String = "Size: \(NSStringFromCGSize(self.image.size))  -  Orientation: \(String(self.image.imageOrientation))"
        self.infoLabel = UILabel(frame: CGRectMake(0, 0, screenRect.size.width, 20))
        self.infoLabel.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.7);
        self.infoLabel.textColor = UIColor.whiteColor()
        self.infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 13)
        self.infoLabel.textAlignment = .Center
        self.infoLabel.text = info
        self.view!.addSubview(self.infoLabel)

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped:")
        self.view!.addGestureRecognizer(tapGesture)
    }
    
    func viewTapped(gesture: UIGestureRecognizer) {
        self.dismissViewControllerAnimated(false, completion: { _ in })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.imageView.frame = self.view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
