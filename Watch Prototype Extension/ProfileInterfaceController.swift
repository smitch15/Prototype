//
//  ProfileInterfaceController.swift
//  Prototype
//
//  Created by Steven Mitchell on 9/10/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

import WatchKit
import Foundation


class ProfileInterfaceController: WKInterfaceController {

    @IBOutlet var eduButton: WKInterfaceButton!
    @IBOutlet var jobButton: WKInterfaceButton!
    @IBOutlet var intThreeButton: WKInterfaceButton!
    @IBOutlet var intTwoButton: WKInterfaceButton!
    @IBOutlet var intOneButton: WKInterfaceButton!
    @IBOutlet var emojiButton: WKInterfaceButton!
    @IBOutlet var nameButton: WKInterfaceButton!
    
    private var appGroupDefaults = NSUserDefaults(suiteName: "com.pathos.Prototype")!
    var contactListDict:NSDictionary = [:]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // get the contactList
        contactListDict = self.appGroupDefaults.dictionaryForKey("contactListInfo")!
        // access profileInfo from contListDict using name string that was selected
        var profileInfo: Dictionary<String, String> = contactListDict[(context as? NSCopying)!]! as! Dictionary<String, String>
        self.eduButton.setTitle(profileInfo["edu"])
        self.jobButton.setTitle(profileInfo["occ"])
        self.intOneButton.setTitle(profileInfo["int1"])
        self.intTwoButton.setTitle(profileInfo["int2"])
        self.intThreeButton.setTitle(profileInfo["int3"])
        //self.emojiButton.setTitle("")
        //self.emojiButton.setBackgroundImageNamed("sadFace")
        let happyEmoji = "\u{1F604}"
        let flatEmoji = "\u{1F610}"
        let upsetEmoji = "\u{1F612}"
        print(upsetEmoji)
        
        let vibe:String = profileInfo["Vibe"]!
        if (vibe == "Neutral"){
            // set button background to emoji image
            
            self.nameButton.setTitle((context as? String)! + flatEmoji)
        } else if (vibe == "Unhappy"){
            self.nameButton.setTitle((context as? String)! + upsetEmoji)
        } else if (vibe == "Happy"){
            self.nameButton.setTitle((context as? String)! + happyEmoji)
        }
        
 }
    
    // use this function with the false bool in order to present profile Info UI

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func changeEdu() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in

            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.eduButton.setTitle(aResult)
            }
        })
    }

    @IBAction func changeOcc() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
    
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.jobButton.setTitle(aResult)
            }
        })
    }
    
    @IBAction func changeInt3() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.intThreeButton.setTitle(aResult)
            }
        })
    }
    
    @IBAction func changeInt2() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.intTwoButton.setTitle(aResult)
            }
        })
    }
    
    @IBAction func changeInt1() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.intOneButton.setTitle(aResult)
            }
        })
    }
    
    @IBAction func changeEmoji() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.emojiButton.setTitle(aResult)
            }
        })
    }
    
    @IBAction func changeName() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.nameButton.setTitle(aResult)
            }
        })
    }
    
}
