//
//  contactList.swift
//  Prototype
//
//  Created by Anthony Parente on 8/25/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

import Foundation
import WatchKit

class contactList: WKInterfaceController {
    
    @IBOutlet var headerContactList: WKInterfaceLabel!
    @IBOutlet var contactListSeparator: WKInterfaceSeparator!
    @IBOutlet var tableView: WKInterfaceTable!
    @IBOutlet var encouragementLabel: WKInterfaceLabel!
    
    private var appGroupDefaults = NSUserDefaults(suiteName: "com.pathos.Prototype")!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        setupTable()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        var contactListDict:NSDictionary = appGroupDefaults.dictionaryForKey("contactListInfo")!
        let contacts = contactListDict.allKeys
        var contactsAsStringArr: [String]
        contactsAsStringArr = (contacts as? [String])!
        return contactsAsStringArr[rowIndex]
    }
    
    func setupTable() {
        print(appGroupDefaults.dictionaryForKey("contactListInfo"))
        if(appGroupDefaults.dictionaryForKey("contactListInfo") != nil){
            var contactListDict:NSDictionary = appGroupDefaults.dictionaryForKey("contactListInfo")!
            let contacts = contactListDict.allKeys
            var contactsAsStringArr: [String]
            contactsAsStringArr = (contacts as? [String])!
            let locale = NSLocale(localeIdentifier: "en")
            contactsAsStringArr.sort {
                $0.compare($1, locale: locale) == .OrderedAscending
            }
            
            tableView.setNumberOfRows(contactsAsStringArr.count, withRowType: "rowController")
            
            if(contactsAsStringArr.count > 4){
                self.encouragementLabel.setHidden(true)
            }
            
            for(var i = 0; i < contactsAsStringArr.count; i+=1) {
                
                if let row = tableView.rowControllerAtIndex(i) as? rowController {
                    row.contactLabel.setText(contacts[i] as? String)
                }
            }
        }
    }
    
}