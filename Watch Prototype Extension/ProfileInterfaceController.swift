//
//  ProfileInterfaceController.swift
//  Prototype
//
//  Created by Anthony Parente on 9/11/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class ProfileInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var jobLabel: WKInterfaceLabel!
    @IBOutlet var eduLabel: WKInterfaceLabel!
    
    @IBOutlet var table: WKInterfaceTable!
    
    private let session = WCSession.defaultSession()
    private var appGroupDefaults = NSUserDefaults(suiteName: "com.pathos.Prototype")!
    var contactListDict:NSDictionary = [:]
    //var profileInfo: Dictionary<String, AnyObject> = [:]
    
    var profileInfo:NSDictionary = [:]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        setTitle("Contacts")
        // get the contactList
        self.contactListDict = self.appGroupDefaults.dictionaryForKey("contactListInfo")!
        // access profileInfo from contListDict using name string that was selected
        self.profileInfo = self.contactListDict[(context as! String)]! as! NSDictionary
        let happyEmoji = " \u{1F603}"
        let flatEmoji = " \u{1F610}"
        let upsetEmoji = " \u{1F612}"
        
        let vibe:String = self.profileInfo["Vibe"]! as! String
        if (vibe == "Neutral"){
            self.nameLabel.setText((context as? String)! + flatEmoji)
        } else if (vibe == "Unhappy"){
            self.nameLabel.setText((context as? String)! + upsetEmoji)
        } else if (vibe == "Happy"){
            self.nameLabel.setText((context as? String)! + happyEmoji)
        }else if (vibe == "maybeLater") {
             self.nameLabel.setText(context as? String)
        }
        self.eduLabel.setText(self.profileInfo["edu"] as? String)
        self.jobLabel.setText(self.profileInfo["occ"] as? String)
        let talkPointArray = self.profileInfo["talkingPointArray"] as! NSMutableArray
        self.setupTable(talkPointArray)
        
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        var talkingPointArray:NSMutableArray = self.profileInfo["talkingPointArray"] as! NSMutableArray
        
        if(rowIndex == talkingPointArray.count){
            self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
                if results != nil && results!.count > 0 {
                    let aResult = results![0] as? String
                    talkingPointArray.addObject(aResult!)
                    self.updateProfInfo("talkingPointArray", aResult: talkingPointArray)
                    self.setupTable(talkingPointArray)
                }
            })
            
        }else{
            self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
                if results != nil && results!.count > 0 { //selection made
                    let aResult = results?[0] as? String
                    talkingPointArray.removeObjectAtIndex(rowIndex)
                    talkingPointArray.addObject(aResult!)
                    self.updateProfInfo("talkingPointArray", aResult: talkingPointArray)
                    self.setupTable(talkingPointArray)
                }
                
            })
        }
        
    }
    
    func setupTable(talkPointArray:NSMutableArray) {
        
        let plusColor = UIColor(red: 0.95127833210000001, green:0.37017731129999998, blue:1, alpha:1)
        if(talkPointArray.count > 0){
            let numOfRows = talkPointArray.count + 1
            
            table.setNumberOfRows(numOfRows, withRowType: "profVisualRowController")
            
            for(var i = 0; i < talkPointArray.count; i+=1) {
                if let row = table.rowControllerAtIndex(i) as? profVisualRowController {
                    row.talkPointLabel.setText(talkPointArray[i] as? String)
                    
                }
            }
            if let row = table.rowControllerAtIndex(talkPointArray.count) as? profVisualRowController{
                row.talkPointLabel.setText("+")
                row.talkPointLabel.setTextColor(plusColor)
                
            }
            
        }
        
    }
    
    
    // use this function with the false bool in order to present profile Info UI
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        WCSession.defaultSession().delegate = self
        WCSession.defaultSession().activateSession()
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
                self.updateProfInfo("edu", aResult: aResult!)
            }
            
        })
    }
    
    @IBAction func changeOcc() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.jobLabel.setText(aResult)
                self.updateProfInfo("occ", aResult: aResult!)
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
            let oldName = self.profileInfo["name"]  as! String
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.nameLabel.setText(aResult)
                self.profileInfo.setValue(aResult!, forKey: "name")
                self.updateNameInProfile(oldName)
            }
        })
    }
    
    func updateProfInfo(partOfProfNotName:String, aResult:AnyObject){
        
        var contactListInfo = self.appGroupDefaults.dictionaryForKey("contactListInfo")!
        let contactName = self.profileInfo["name"]  as! String
        self.profileInfo.setValue(aResult, forKey: partOfProfNotName)
        contactListInfo.updateValue(self.profileInfo, forKey: contactName)
        self.appGroupDefaults.setObject(contactListInfo, forKey: "contactListInfo")
        self.session.transferUserInfo([contactName:self.profileInfo])
        
    }
    func updateNameInProfile(oldName: String){
        
        var contactListInfo = self.appGroupDefaults.dictionaryForKey("contactListInfo")!
        let contactName = self.profileInfo["name"] as! String
        contactListInfo.removeValueForKey(oldName)
        contactListInfo.updateValue(self.profileInfo, forKey: contactName)
        self.appGroupDefaults.setObject(contactListInfo, forKey: "contactListInfo")
        self.session.transferUserInfo([contactName:self.profileInfo])
        
    }
    
    
}
