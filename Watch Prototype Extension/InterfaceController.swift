//
//  InterfaceController.swift
//  Watch Prototype Extension
//
//  Created by Anthony Parente on 8/2/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, WCSessionDelegate {

    let audioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("audioFile", ofType: "wav")!)
    let arrayURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("array", ofType: "txt")!)
    
    @IBOutlet var EducationButton: WKInterfaceButton!
    @IBOutlet var InterestNum3: WKInterfaceButton!
    @IBOutlet var InterestNum2: WKInterfaceButton!
    @IBOutlet var InterestNum1: WKInterfaceButton!
    
    @IBOutlet var IntNum1Label: WKInterfaceLabel!
    @IBOutlet var IntNum2Label: WKInterfaceLabel!
    @IBOutlet var IntNum3Label: WKInterfaceLabel!
    
    @IBOutlet var NameButton: WKInterfaceButton!
    @IBOutlet var OccButton: WKInterfaceButton!
    @IBOutlet var ConfirmButton: WKInterfaceButton!
    @IBOutlet var DeleteButton: WKInterfaceButton!
    
    @IBOutlet var processingLabel: WKInterfaceLabel!
    @IBOutlet var pathosButton: WKInterfaceButton!
    @IBOutlet var contactListButton: WKInterfaceButton!
    @IBOutlet var ConfirmationSettingsLabel: WKInterfaceLabel!
    @IBOutlet var LabelConfirmSettings: WKInterfaceSeparator!
    @IBOutlet var LabelForName: WKInterfaceLabel!
    @IBOutlet var LabelForOcc: WKInterfaceLabel!
    @IBOutlet var LabelForEducation: WKInterfaceLabel!
    @IBOutlet var LabelForTalkPoints: WKInterfaceLabel!
    @IBOutlet var Separator1: WKInterfaceSeparator!
    @IBOutlet var Separator2: WKInterfaceSeparator!
    @IBOutlet var Separator3: WKInterfaceSeparator!
    @IBOutlet var Separator4: WKInterfaceSeparator!
    
    @IBOutlet var loadingScreen: WKInterfaceImage!
    
    //////////////////////////////
    @IBOutlet var TheVibeLabel: WKInterfaceLabel!
    @IBOutlet var emojiGroup: WKInterfaceGroup!
    @IBOutlet var happyButtonOutlet: WKInterfaceButton!
    @IBOutlet var neutralButtonOutlet: WKInterfaceButton!
    @IBOutlet var unhappyButtonOutlet: WKInterfaceButton!
    @IBOutlet var maybeLaterButton: WKInterfaceButton!
    //////////////////////////////9/1/2016
    
    var profileInfo: Dictionary <String, String> = [:]
    
    ///////////////////////////
    //I deleted this variable
    //var contactListInfo: Dictionary<String, Dictionary<String,String>> = [:]
    /////////////////////////// 8/28 9:35AM
    
    private let session = WCSession.defaultSession()
    private var appGroupDefaults = NSUserDefaults(suiteName: "com.pathos.Prototype")!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }

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

    @IBAction func buttonPressed() {
        print("pressed")
        self.audioRecording()
        
    }
    
 
    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
        
        let hideUI = false
        
        print("Received File with URL: \(file.fileURL)")
        let data = NSData(contentsOfURL: file.fileURL)
        data!.writeToURL(self.arrayURL, atomically: false)
        self.loadingScreenVisual(true)
        self.setProfileVisual()
        
        self.toggleProfileUI(hideUI)
        
        
        //let masterArray = NSMutableArray(contentsOfURL: self.arrayURL)

    }
    
    func toggleProfileUI(value:Bool){
        self.ConfirmationSettingsLabel.setHidden(value)
        self.LabelConfirmSettings.setHidden(value)
        self.LabelForName.setHidden(value)
        self.Separator1.setHidden(value)
        self.NameButton.setHidden(value)
        self.LabelForOcc.setHidden(value)
        self.Separator2.setHidden(value)
        self.OccButton.setHidden(value)
        self.LabelForEducation.setHidden(value)
        self.Separator3.setHidden(value)
        self.EducationButton.setHidden(value)
        self.LabelForTalkPoints.setHidden(value)
        self.Separator4.setHidden(value)
        self.InterestNum1.setHidden(value)
        self.InterestNum2.setHidden(value)
        self.InterestNum3.setHidden(value)
        self.ConfirmButton.setHidden(value)
        self.DeleteButton.setHidden(value)
        
        if(value == false){
            self.pathosButton.setHidden(true)
            self.contactListButton.setHidden(true)
        
        }
        
    }
    
    
    func setProfileVisual(){
        let masterArray = NSMutableArray(contentsOfURL: self.arrayURL)!
        
        if(masterArray.count > 0){
            let keywordArray = masterArray[0] as! NSMutableArray
            let entityTextArray = masterArray[1] as! NSMutableArray
            let entityTypeArray = masterArray[2] as! NSMutableArray
            let taxonomyArray = masterArray[3] as! NSMutableArray
            let conceptArray = masterArray[4] as! NSMutableArray
            let emotionArray = masterArray[5] as! NSMutableArray
            let occOrg_TR_MutArray = masterArray[6] as! NSMutableArray
            let occCompany_Entity_MutArray = masterArray[7] as! NSMutableArray
            let occJobTitle_Entity_MutArray = masterArray[8] as! NSMutableArray
            let education_MutArray = masterArray[9] as! NSMutableArray
            let edu_MutArray_through_TR = masterArray[10] as! NSMutableArray
            let userInfo_MutArray = masterArray[11] as! NSMutableArray
            let userFirstName = userInfo_MutArray[0] as! String
            let userLastName = userInfo_MutArray[1] as! String
            let userEducation = userInfo_MutArray[2] as! String
            let userCompany = userInfo_MutArray[3] as! String
            let userOcc = userInfo_MutArray[4] as! String
            let transcriptDictArray = masterArray[12] as! NSMutableArray
            
            var taxonomyArray_WO_slashes: NSMutableArray = []
            
            for(var i = 0; i < taxonomyArray.count; i += 1){
                var curTax = taxonomyArray[i] as! String
                let x = curTax.stringByReplacingOccurrencesOfString("/", withString: " with an interest in ")
                print(x)
                taxonomyArray_WO_slashes.addObject(x)
            }
            
            if(emotionArray.count > 0){
               
            }
            
            let edu = self.setEducation(education_MutArray, edu_MutArray_through_TR: edu_MutArray_through_TR, userEducation: userEducation)
            self.contactNameFunc(entityTextArray, entityTypeArray: entityTypeArray, userFirstName: userFirstName, userLastName: userLastName)
            self.occupationFunc(occOrg_TR_MutArray, occCompany_Entity_MutArray: occCompany_Entity_MutArray, occJobTitle_Entity_MutArray: occJobTitle_Entity_MutArray, edu_MutArray_through_TR: edu_MutArray_through_TR, userCompany: userCompany, userOcc: userOcc)
            self.interestFunc(transcriptDictArray)
           // if(taxonomyArray_WO_slashes.count > 0){
             //   self.InterestNum3.setTitle(taxonomyArray_WO_slashes[1] as! String)
            //}
            
        
        }
    }
    
    func interestFunc(transcriptDictArray: NSMutableArray){
        var interestSent1 = "empty"
        var interestSent2 = "empty"
        var interestSent3 = "empty"
        
        if(transcriptDictArray.count > 0) {
            let dictionary:Dictionary<String, NSMutableArray> = transcriptDictArray[0] as! Dictionary<String, NSMutableArray>
            let interestArray = dictionary["interestArr"]!
            let wantArray = dictionary["wantArr"]!
            if(interestArray.count > 0){
                for(var i = 0; i <= interestArray.count; i += 1){
                    if(i == 0){
                        interestSent1 = interestArray[0] as! String
                    }
                    if(i == 1){
                        interestSent2 = interestArray[1] as! String
                    }
                    if(i == 2){
                        interestSent3 = interestArray[2] as! String
                    }
                }
            }
            
            if(wantArray.count > 0){
                for(var i = 0; i <= interestArray.count; i += 1){
                    if(interestSent1 == "empty"){
                        interestSent1 = wantArray[i] as! String
                    }
                    else if(interestSent2 == "empty"){
                        interestSent2 = wantArray[i] as! String
                    }
                    else if(interestSent3 == "empty"){
                        interestSent3 = wantArray[i] as! String
                    }
                }
            }
            
            self.IntNum1Label.setText("1. \(interestSent1)")
            self.profileInfo["int1"] = interestSent1
            self.IntNum2Label.setText("2. \(interestSent2)")
            self.profileInfo["int2"] = interestSent2
            self.IntNum3Label.setText("3. \(interestSent3)")
            self.profileInfo["int3"] = interestSent3

        }
        
    }
    
    func setEducation(education_MutArray:NSMutableArray, edu_MutArray_through_TR:NSMutableArray, userEducation: String) -> String{
        var education: String = "Please Enter Education"
        
        var eduMutWO = ""
        var eduWithTR = ""
        
        if(education_MutArray.count > 0 || edu_MutArray_through_TR.count > 0){
            
            if(education_MutArray.count > 0){
                eduMutWO = education_MutArray[0] as! String
            }
            if(edu_MutArray_through_TR.count > 0){
                eduWithTR = edu_MutArray_through_TR[0] as! String
            }
            
            if(education_MutArray.count > 0 && eduMutWO.lowercaseString != userEducation.lowercaseString){
                education = education_MutArray[0] as! String
            }
            if(education == "Please Enter Education" && edu_MutArray_through_TR.count > 0 && eduWithTR.lowercaseString != userEducation.lowercaseString){
                education = edu_MutArray_through_TR[0] as! String
            }
        }
        self.EducationButton.setTitle(education)
        self.profileInfo["edu"] = education
        return(education)
    }
    
    func contactNameFunc(entityTextArray:NSMutableArray, entityTypeArray:NSMutableArray, userFirstName: String, userLastName: String){
        
        let userFullName = userFirstName + " " + userLastName
        var namePosition: Int = 923
        var contactName: String
        
        for(var i = 0; i < entityTypeArray.count; i += 1){
            if(entityTypeArray[i] as! String == "Person"){
                if(entityTextArray[i] as! String != userFullName && entityTextArray[i] as! String != userFirstName) {
                    namePosition = i as Int                    
                }
            }
        }
        if(namePosition != 923){
            let name = entityTextArray[namePosition] as! String
            self.NameButton.setTitle(name)
            self.profileInfo["name"] = name
        }else{
            self.NameButton.setTitle("Please Enter Name")
            self.profileInfo["name"] = "empty"
        }
    }
    
    func occupationFunc(occOrg_TR_MutArray: NSMutableArray, occCompany_Entity_MutArray: NSMutableArray, occJobTitle_Entity_MutArray: NSMutableArray, edu_MutArray_through_TR:NSMutableArray, userCompany: String, userOcc: String){
        
        var final = "empty"
        
        let uCompany = userCompany.lowercaseString
        let uJob = userOcc.lowercaseString
        
        var companyThruEntities = "empty"
        
        if(occCompany_Entity_MutArray.count > 0){
            
            if((occCompany_Entity_MutArray[0] as! String).lowercaseString != uCompany){
                companyThruEntities = occCompany_Entity_MutArray[0] as! String
            }else{
                if(occCompany_Entity_MutArray.count > 1){
                    companyThruEntities = occCompany_Entity_MutArray[1] as! String
                }
            }
        }
        
        var orgOrCompanyThruTR = "empty"
        
        if(occOrg_TR_MutArray.count > 0){
            if((occOrg_TR_MutArray[0] as! String).lowercaseString != uCompany){
                orgOrCompanyThruTR = occCompany_Entity_MutArray[0] as! String
            }else{
                if(occOrg_TR_MutArray.count > 1){
                    orgOrCompanyThruTR = occOrg_TR_MutArray[1] as! String
                }
            }
        }
        
        var jobTitle = "empty"
        
        if(occJobTitle_Entity_MutArray.count > 0){
            if((occJobTitle_Entity_MutArray[0] as! String).lowercaseString != uJob){
                jobTitle = occJobTitle_Entity_MutArray[0] as! String
            }else{
                if(occJobTitle_Entity_MutArray.count > 1){
                    jobTitle = occJobTitle_Entity_MutArray[1] as! String
                }
            }
        }
        
        
        if(jobTitle != "empty"){
            let jobTitle = occJobTitle_Entity_MutArray[0] as! String
            if(companyThruEntities != "empty"){
                final = "\(jobTitle)@\(companyThruEntities)"
            }else if(orgOrCompanyThruTR != "empty"){
                final = "\(jobTitle)@\(orgOrCompanyThruTR)"
            }else{
                final = jobTitle
            }
        }else if(jobTitle == "empty"){
            if(companyThruEntities != "empty"){
                final = "works @\(companyThruEntities)"
            }else if(orgOrCompanyThruTR != "empty"){
                final = "works @\(orgOrCompanyThruTR)"
            }
        }else if(edu_MutArray_through_TR.count > 0){
            let edu = edu_MutArray_through_TR[0] as! String
            final = "student @\(edu)"
        }else if(edu_MutArray_through_TR.count <= 0){
            final = "Please Enter Occupation"
        }
        self.OccButton.setTitle(final)
        self.profileInfo["occ"] = final
    }
/*
    @IBAction func contctListChecker() {
        self.pathosButton.setHidden(true)
        self.contactListButton.setHidden(true)
    }
*/
    func audioRecording(){
        
        let duration = NSTimeInterval(Double.infinity)
        let recordOptions = [WKAudioRecorderControllerOptionsMaximumDurationKey: duration, WKAudioRecorderControllerOptionsActionTitleKey: "Completed"]
        self.presentAudioRecorderControllerWithOutputURL(self.audioURL, preset: WKAudioRecorderPreset.HighQualityAudio, options: recordOptions as [NSObject : AnyObject], completion:{ (didSave, error) -> Void in
            if(error == nil && didSave == true){
                print("saved to \(self.audioURL)")
                self.session.transferFile(self.audioURL, metadata: nil)
                print(self.session.outstandingFileTransfers)
                self.contactListButton.setHidden(true)
                self.loadingScreenVisual(false)
                //self.loadingScreen.setHidden(false)
                self.pathosButton.setHidden(true)
            }else{
                print(error)
            }
            
        })

    }
    
    func loadingScreenVisual(boolValue: Bool){
        if(boolValue == false){
            self.loadingScreen.setImageNamed("frame")
            self.loadingScreen.startAnimatingWithImagesInRange(NSRange(location: 0,length: 243), duration: 8, repeatCount: Int.max)
        }
 
        self.loadingScreen.setHidden(boolValue)
        
        if(boolValue == true){
            self.loadingScreen.stopAnimating()
        }
        
    }
    
    @IBAction func pressedConfirm(){
        let hideUI = true
        
        self.pathosButton.setHidden(false)
        self.contactListButton.setHidden(false)
        self.toggleProfileUI(hideUI)
        
        /////
        self.emojiGroup.setHidden(false)
        self.TheVibeLabel.setHidden(false)
        self.maybeLaterButton.setHidden(false)
        ////
        
        ///////////////////////////delete below
        /*
        self.pathosButton.setHidden(false)
        self.contactListButton.setHidden(false)
        //replaced the comment bloack with this code to prevent contactList from continuously being overwritten wiith only the new profile
        
        var contactListInfo:NSDictionary = appGroupDefaults.dictionaryForKey("contactListInfo")!
        let contactName = self.profileInfo["name"]
        contactListInfo.setValue(self.profileInfo, forKey: contactName!)
        self.appGroupDefaults.setObject(contactListInfo, forKey: "contactListInfo")

        
        /*let contactName = self.profileInfo["name"]
        
        self.contactListInfo[contactName!] = self.profileInfo
        self.appGroupDefaults.setObject(self.contactListInfo, forKey: "contactListInfo")
        */
        */
        /////////////////////////// 9/1/2016
        
        
        //save the data that went through as a contact
        print(appGroupDefaults.dictionaryForKey("contactListInfo"))
    }
    
    @IBAction func pressedDelete() {
        //TODO
        //don't save the data that went through as a contact
        //go back to recording screen
    }
    
    @IBAction func pressedName() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.profileInfo["name"] = aResult
                self.NameButton.setTitle(aResult)
            }
        })
    }
    
    @IBAction func pressedOcc() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.profileInfo["occ"] = aResult
                self.OccButton.setTitle(aResult)
            }
        })
    }
    
    // combine all three talking points into a table and make a plus button to add more if wanted
    @IBAction func pressedInt1() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.AllowEmoji, completion: { (results) -> Void in
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.profileInfo["int1"] = aResult
                /*if self.keywordContent.count > 0 {
                 let derp = self.keywordContent[0] as? String
                 print()
                 print(derp)
                 self.InterestNum1.setTitle(derp) // (self.profileInfo["Int1"])
                 }*/
            }
        })
    }
    
    // combine all three talking points into a table and make a plus button to add more if wanted
    @IBAction func pressedInt2() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.profileInfo["int2"] = aResult
                self.InterestNum2.setTitle(aResult)
            }
        })
    }
    
    // combine all three talking points into a table and make a plus button to add more if wanted
    @IBAction func pressedInt3() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.AllowEmoji, completion: { (results) -> Void in
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.profileInfo["int3"] = aResult
                self.InterestNum3.setTitle(aResult)
            }
        })
    }
////////////////////// Emoji update
    @IBOutlet var happyButtonOutlet: WKInterfaceButton!
    @IBOutlet var neutralButtonOutlet: WKInterfaceButton!
    @IBOutlet var unhappyButtonOutlet: WKInterfaceButton!
    
    func toggleContactListUI(value: Bool){
        
        self.ConfirmationSettingsLabel.setHidden(value)
        //self.LabelConfirmSettings.setHidden(value)
        self.LabelForName.setHidden(value)
        self.Separator1.setHidden(value)
        self.NameButton.setHidden(value)
        self.LabelForOcc.setHidden(value)
        self.Separator2.setHidden(value)
        self.OccButton.setHidden(value)
        self.LabelForEducation.setHidden(value)
        self.Separator3.setHidden(value)
        self.EducationButton.setHidden(value)
        self.LabelForTalkPoints.setHidden(value)
        self.Separator4.setHidden(value)
        self.InterestNum1.setHidden(value)
        self.InterestNum2.setHidden(value)
        self.InterestNum3.setHidden(value)
        self.ConfirmButton.setHidden(value)
        self.DeleteButton.setHidden(value)
        self.pathosButton.setHidden(value)
        self.contactListButton.setHidden(value)
        
        print(value)
        print(!value)
        
        self.emojiGroup.setHidden(!value)
        self.TheVibeLabel.setHidden(!value)
    }
    
    // press the contact list button for now as a test. this is code after confirm is pressed in reality
    // just check if this works for now
    @IBAction func pressedContList() {
        let hide: Bool = true
        toggleContactListUI(hide)
    }
    
    // print happy on happy button if presseed as a test
    @IBAction func pressedHappy() {
        profileInfo["Vibe"] = "Happy"
        happyButtonOutlet.setTitle(profileInfo["Vibe"])
/////////////////////////////////////////////////////////
        self.saveContactList()
/////////////////////////////////////////////////////////9/1/2016
    }
    
    // print neutral on happybutton as a test
    @IBAction func pressedNeutral() {
        profileInfo["Vibe"] = "Neutral"
        happyButtonOutlet.setTitle(profileInfo["Vibe"])
/////////////////////////////////////////////////////////
        self.saveContactList()
/////////////////////////////////////////////////////////9/1/2016

    }
    
    // print unhappy on unhappy button as a test
    @IBAction func pressedUnhappy(){
        profileInfo["Vibe"] = "Unhappy"
        unhappyButtonOutlet.setTitle(profileInfo["Vibe"])
/////////////////////////////////////////////////////////
        self.saveContactList()
/////////////////////////////////////////////////////////9/1/2016
    }
/////////////////////////////

    
    @IBAction func pressedEducationButton() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.profileInfo["edu"] = aResult
                self.EducationButton.setTitle(aResult)
            }
        })
    }
    
////////////////////////////////////////

@IBAction func maybeLater(){
        self.saveContactList()
        
        self.pathosButton.setHidden(false)
        self.contactListButton.setHidden(false)
        self.emojiGroup.setHidden(true)
        self.TheVibeLabel.setHidden(true)
        self.maybeLaterButton.setHidden(true)
    }

func saveContactList(){
        var contactListInfo = self.appGroupDefaults.dictionaryForKey("contactListInfo")!
        let contactName = self.profileInfo["name"]
        contactListInfo.updateValue(self.profileInfo, forKey: contactName!)
        self.appGroupDefaults.setObject(contactListInfo, forKey: "contactListInfo")
        //save the data that went through as a contact
        print(appGroupDefaults.dictionaryForKey("contactListInfo"))
        self.session.transferUserInfo([contactName!:self.profileInfo])
    }

////////////////////////////////////////9/1/2016

}
