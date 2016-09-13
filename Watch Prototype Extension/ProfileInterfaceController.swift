//
//  ProfileInterfaceController.swift
//  Prototype
//
//  Created by Anthony Parente on 9/11/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

import WatchKit
import Foundation


class ProfileInterfaceController: WKInterfaceController {
    
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var jobLabel: WKInterfaceLabel!
    @IBOutlet var eduLabel: WKInterfaceLabel!
    @IBOutlet var intOneLabel: WKInterfaceLabel!
    @IBOutlet var intTwoLabel: WKInterfaceLabel!
    @IBOutlet var intThreeLabel: WKInterfaceLabel!
    
    
    private var appGroupDefaults = NSUserDefaults(suiteName: "com.pathos.Prototype")!
    var contactListDict:NSDictionary = [:]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        setTitle("Contacts")
        // get the contactList
        contactListDict = self.appGroupDefaults.dictionaryForKey("contactListInfo")!
        // access profileInfo from contListDict using name string that was selected
        var profileInfo: Dictionary<String, String> = contactListDict[(context as? NSCopying)!]! as! Dictionary<String, String>
        let happyEmoji = " \u{1F603}"
        let flatEmoji = " \u{1F610}"
        let upsetEmoji = " \u{1F612}"
        
        let vibe:String = profileInfo["Vibe"]!
        if (vibe == "Neutral"){
            self.nameLabel.setText((context as? String)! + flatEmoji)
        } else if (vibe == "Unhappy"){
            self.nameLabel.setText((context as? String)! + upsetEmoji)
        } else if (vibe == "Happy"){
            self.nameLabel.setText((context as? String)! + happyEmoji)
        }else{
             self.nameLabel.setText(context as? String)
        }
        self.eduLabel.setText(profileInfo["edu"])
        self.jobLabel.setText(profileInfo["occ"])
        self.intOneLabel.setText(profileInfo["int1"])
        self.intTwoLabel.setText(profileInfo["int2"])
        self.intThreeLabel.setText(profileInfo["int3"])
        
        
        
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
                self.eduLabel.setText(aResult)
            }
        })
    }
    
    @IBAction func changeOcc() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.jobLabel.setText(aResult)
            }
        })
    }
    
    @IBAction func changeInt3() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.intThreeLabel.setText(aResult)
            }
        })
    }
    
    @IBAction func changeInt2() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.intTwoLabel.setText(aResult)
            }
        })
    }
    
    @IBAction func changeInt1() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.intOneLabel.setText(aResult)
            }
        })
    }
    
   /* @IBAction func changeEmoji() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.emojiLabel.setText(aResult)
            }
        })
    }*/
    
    @IBAction func changeName() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.nameLabel.setText(aResult)
            }
        })
    }
    
}
