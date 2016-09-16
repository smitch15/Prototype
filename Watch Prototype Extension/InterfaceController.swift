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
   
    
    @IBOutlet var NameButton: WKInterfaceButton!
    @IBOutlet var OccButton: WKInterfaceButton!
    @IBOutlet var ConfirmButton: WKInterfaceButton!
    @IBOutlet var DeleteButton: WKInterfaceButton!
    
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
    
    @IBOutlet var TheVibeLabel: WKInterfaceImage!
    @IBOutlet var emojiGroup: WKInterfaceGroup!
    @IBOutlet var happyButtonOutlet: WKInterfaceButton!
    @IBOutlet var neutralButtonOutlet: WKInterfaceButton!
    @IBOutlet var unhappyButtonOutlet: WKInterfaceButton!
    @IBOutlet var maybeLaterButton: WKInterfaceButton!
    
    @IBOutlet var table: WKInterfaceTable!
    
    var profileInfo: Dictionary <String, AnyObject> = [:]
    
    
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
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        var talkingPointArray:NSMutableArray = self.profileInfo["talkingPointArray"] as! NSMutableArray
        
        if(rowIndex == talkingPointArray.count){
            print("plus")
            
            self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
                if results != nil && results!.count > 0 {
                    let aResult = results![0] as? String
                    talkingPointArray.addObject(aResult!)
                    self.profileInfo["talkingPointArray"] = talkingPointArray
                    self.setupTable(talkingPointArray)
                }
            })
        
        }else{
            print("the others")
            
            self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
                if results != nil && results!.count > 0 { //selection made
                    let aResult = results?[0] as? String
                    talkingPointArray.removeObjectAtIndex(rowIndex)
                    talkingPointArray.addObject(aResult!)
                    self.profileInfo["talkingPointArray"] = talkingPointArray
                    self.setupTable(talkingPointArray)
                }
 
            })
        }
        
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
            
            
            
            //print(keywordArray, entityTextArray, entityTypeArray, taxonomyArray, conceptArray, emotionArray, occOrg_TR_MutArray, occCompany_Entity_MutArray, occJobTitle_Entity_MutArray, education_MutArray, edu_MutArray_through_TR, userInfo_MutArray, userFirstName, userLastName, userEducation, userCompany, userOcc)
            
            
            
            
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
            print(edu)
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
        var talkingPointArray: NSMutableArray = []
        
        if(transcriptDictArray.count > 0) {
            let dictionary = transcriptDictArray[0] as! Dictionary<String, NSMutableArray>
            
            if(dictionary["interestArr"] != nil){
                let interestArray = dictionary["interestArr"]!
                if(interestArray.count > 0){
                    for(var i = 0; i < interestArray.count; i += 1){
                        if(i == 0){
                            interestSent1 = interestArray[0] as! String
                        }
                        if(i == 1){
                            interestSent2 = interestArray[1] as! String
                        }
                        if(i == 2){
                            interestSent3 = interestArray[2] as! String
                        }
                        talkingPointArray.addObject(interestArray[i] as! String)
                    }
                }
            }
            
            if(dictionary["wantArr"] != nil){
                let wantArray = dictionary["wantArr"]!
                
                if(wantArray.count > 0){
                    for(var i = 0; i < wantArray.count; i += 1){
                        if(interestSent1 == "empty"){
                            interestSent1 = wantArray[i] as! String
                        }
                        else if(interestSent2 == "empty"){
                            interestSent2 = wantArray[i] as! String
                        }
                        else if(interestSent3 == "empty"){
                            interestSent3 = wantArray[i] as! String
                        }
                        talkingPointArray.addObject(wantArray[i] as! String)
                    }
                }
            }
            
            print(talkingPointArray)
            self.profileInfo["talkingPointArray"] = talkingPointArray
            
            self.setupTable(talkingPointArray)
            
        }
    }
    
    // use this function with the false bool in order to present profile Info UI
    func toggleProfileUI(value:Bool){
        // all of these items will become visible, they are profileInfo objects
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
        self.table.setHidden(value)
        self.ConfirmButton.setHidden(value)
        self.DeleteButton.setHidden(value)
        
        if(value == false){
            // all of the items will be hidden
            self.pathosButton.setHidden(true)
            self.contactListButton.setHidden(true)
            
        }
    }
    
    func setupTable(talkPointArray:NSMutableArray) {
        let plusColor = UIColor(red: 0.95127833210000001, green:0.37017731129999998, blue:1, alpha:1)
        if(talkPointArray.count > 0){
            let numOfRows = talkPointArray.count + 1
            
            table.setNumberOfRows(numOfRows, withRowType: "talkingPointRowController")
            
            for(var i = 0; i < talkPointArray.count; i+=1) {
                if let row = table.rowControllerAtIndex(i) as? talkingPointRowController {
                    row.talkPointLabel.setText(talkPointArray[i] as? String)
                }
            }
            if let row = table.rowControllerAtIndex(talkPointArray.count) as? talkingPointRowController{
                row.talkPointLabel.setText("+")
                row.talkPointLabel.setTextColor(plusColor)
            }
            
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
        print(education)
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
            print(name)
            self.profileInfo["name"] = name
        }else{
            self.NameButton.setTitle("Please Enter Name")
            self.profileInfo["name"] = "no name"
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
        print(final)
    }
    
    @IBAction func contctListChecker() {
        self.pathosButton.setHidden(true)
        self.contactListButton.setHidden(true)
    }
    
    func audioRecording(){
        
        let duration = NSTimeInterval(Double.infinity)
        let recordOptions = [WKAudioRecorderControllerOptionsMaximumDurationKey: duration, WKAudioRecorderControllerOptionsActionTitleKey: "Completed"]
        self.presentAudioRecorderControllerWithOutputURL(self.audioURL, preset: WKAudioRecorderPreset.HighQualityAudio, options: recordOptions as [NSObject : AnyObject], completion:{ (didSave, error) -> Void in
            if(error == nil && didSave == true){
                self.profileInfo.removeAll()
                print("saved to \(self.audioURL)")
                self.session.transferFile(self.audioURL, metadata: nil)
                print(self.session.outstandingFileTransfers)
                self.contactListButton.setHidden(true)
                self.loadingScreenVisual(false)
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
        
        self.emojiGroup.setHidden(false)
        self.TheVibeLabel.setHidden(false)
        self.maybeLaterButton.setHidden(false)
        
        self.toggleProfileUI(hideUI)
    }
    
    @IBAction func pressedDelete() {
        let hideUI = true
        self.toggleProfileUI(hideUI)
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
    @IBAction func pressedTalkingPoint() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.AllowEmoji, completion: { (results) -> Void in
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                var array = self.profileInfo["talkingPointArray"] as! NSMutableArray
                array.addObject(aResult!)
                self.profileInfo["talkingPointArray"] = array
            }
        })
    }
    
    // combine all three talking points into a table and make a plus button to add more if wanted

    
    @IBAction func pressedEducationButton() {
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain, completion: { (results) -> Void in
            if results != nil && results!.count > 0 { //selection made
                let aResult = results?[0] as? String
                self.profileInfo["edu"] = aResult
                self.EducationButton.setTitle(aResult)
            }
        })
    }
    
    ////////////////////// Emoji update
    
    
    // print happy on happy button if presseed as a test
    @IBAction func pressedHappy() {
        self.profileInfo["Vibe"] = "Happy"
        self.saveContactList()
        
        self.pathosButton.setHidden(false)
        self.contactListButton.setHidden(false)
        self.emojiGroup.setHidden(true)
        self.TheVibeLabel.setHidden(true)
        self.maybeLaterButton.setHidden(true)
    }
    
    // print neutral on happybutton as a test
    @IBAction func pressedNeutral() {
        self.profileInfo["Vibe"] = "Neutral"
        self.saveContactList()
        
        self.pathosButton.setHidden(false)
        self.contactListButton.setHidden(false)
        self.emojiGroup.setHidden(true)
        self.TheVibeLabel.setHidden(true)
        self.maybeLaterButton.setHidden(true)
    }
    
    // print unhappy on unhappy button as a test
    @IBAction func pressedUnhappy(){
        self.profileInfo["Vibe"] = "Unhappy"
        self.saveContactList()
        
        self.pathosButton.setHidden(false)
        self.contactListButton.setHidden(false)
        self.emojiGroup.setHidden(true)
        self.TheVibeLabel.setHidden(true)
        self.maybeLaterButton.setHidden(true)
    }
    
    
    @IBAction func maybeLater(){
        self.profileInfo["Vibe"] = "maybeLater" 
        self.saveContactList()
        
        print(self.profileInfo)
        
        self.pathosButton.setHidden(false)
        self.contactListButton.setHidden(false)
        self.emojiGroup.setHidden(true)
        self.TheVibeLabel.setHidden(true)
        self.maybeLaterButton.setHidden(true)
    }
    
    //////////////////////////////
    
    func saveContactList(){
        if(self.appGroupDefaults.dictionaryForKey("contactListInfo") != nil){
            print("contact list already existed")
            var contactListInfo = self.appGroupDefaults.dictionaryForKey("contactListInfo")!
            let contactName = self.profileInfo["name"] as! String
            contactListInfo.updateValue(self.profileInfo, forKey: contactName)
            self.appGroupDefaults.setObject(contactListInfo, forKey: "contactListInfo")
            print(appGroupDefaults.dictionaryForKey("contactListInfo"))
            self.session.transferUserInfo([contactName:self.profileInfo])
        }else{
            print("first addition")
            var contactListInfo: [String:AnyObject]
            let contactName = self.profileInfo["name"] as! String
            contactListInfo = [contactName:self.profileInfo]
            self.appGroupDefaults.setObject(contactListInfo, forKey: "contactListInfo")
            print(self.appGroupDefaults.dictionaryForKey("contactListInfo"))
            self.session.transferUserInfo([contactName:self.profileInfo])
        }
        
        if(self.profileInfo.isEmpty == false){
            self.profileInfo.removeAll()
        }
    }
    
    
}
