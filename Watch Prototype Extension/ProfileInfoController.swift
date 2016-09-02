//
//  ProfileInfoController.swift
//  Prototype
//
//  Created by Steven Mitchell on 9/1/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

import WatchKit
import Foundation


class ProfileInfoController: WKInterfaceController {
    
    @IBOutlet var vibeEmojiImage: WKInterfaceImage!
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var nameButton: WKInterfaceButton!
    
    @IBOutlet var occupationLabel:
    
    WKInterfaceLabel!
    @IBOutlet var occupationButton: WKInterfaceButton!
    
    @IBOutlet var talkingPointsLabel: WKInterfaceLabel!

    @IBOutlet var intOneButton: WKInterfaceButton!
    @IBOutlet var intTwoButton: WKInterfaceButton!
    @IBOutlet var intThreeButton: WKInterfaceButton!
    
    @IBOutlet var educationLabel: WKInterfaceLabel!
    @IBOutlet var educationButton: WKInterfaceButton!

    

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        let profileInfoDict = context as? NSDictionary
        nameButton.setTitle(profileInfoDict!["name"] as? String)
        intOneButton.setTitle(profileInfoDict!["int1"] as? String)
        intTwoButton.setTitle(profileInfoDict!["int2"] as? String)
        intThreeButton.setTitle(profileInfoDict!["int3"] as? String)
        educationButton.setTitle(profileInfoDict!["edu"] as? String)
        occupationButton.setTitle(profileInfoDict!["occ"] as? String)
        if("Happy" == profileInfoDict!["vibe"] as? String){
            vibeEmojiImage.setImage(UIImage(named: "HappyImage"))
        } else if ("Neutral" == profileInfoDict!["vibe"] as? String){
            vibeEmojiImage.setImage(UIImage(named: "NeutralImage"))
        } else{
            vibeEmojiImage.setImage(UIImage(named: "UpsetImage"))
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
