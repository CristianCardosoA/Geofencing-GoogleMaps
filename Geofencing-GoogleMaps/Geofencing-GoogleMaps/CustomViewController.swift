//
//  CustomViewController.swift
//  Example of Geotifications
//
//  Created by MacBook on 31/10/16.
//  Copyright © 2016 iTexico. All rights reserved.
//

import UIKit

class CustomViewController: UIView{
    
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var bioLabel: UILabel!
    
    @IBOutlet var image: UIImageView!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction func directions(_ sender: AnyObject) {
        
        /*if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(102.21),\(12.04)&directionsmode=driving")! as URL)
            
        } else {
            NSLog("Can't use comgooglemaps://");
        }*/
        //OPEN GOOGLE MAPS DIRECTIONS.
    }
    
    class func initWithGeotification(name: String, bio : String, image: UIImage? = nil, frame : CGRect) -> UIView{
        
        let customView = UINib(nibName: "CustomView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomViewController
        
        customView.nameLabel.text = name
        customView.nameLabel.numberOfLines = 1
        customView.nameLabel.minimumScaleFactor = 0.5

        customView.bioLabel.text = bio
        customView.bioLabel.numberOfLines = 1
        customView.bioLabel.minimumScaleFactor = 0.5

        
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customView.translatesAutoresizingMaskIntoConstraints = true
        customView.tag = 100
        customView.alpha = 0.9
        customView.isUserInteractionEnabled = true
        customView.frame = frame
        
        customView.dateLabel.numberOfLines = 1
        customView.dateLabel.minimumScaleFactor = 0.5
        customView.dateLabel.adjustsFontSizeToFitWidth = true
        
        if image != nil
        {
            customView.image.image = image
            customView.image.layer.masksToBounds = true
            customView.image.layer.cornerRadius = customView.image.frame.width/5.0

        }
        
        return customView
    }
}
