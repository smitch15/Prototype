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
    
    
   
    
    func setupTable() {
        var contactListDict = appGroupDefaults.dictionaryForKey("contactListInfo")
        var contactsArray: [String]
        var contacts = contactListDict?.keys
        //contactsArray = Array(contactListDict?.keys)
        tableView.setNumberOfRows(contacts!.count, withRowType: "rowController")
        
        for(var i = 0; i < contacts!.count; i+=1) {
            if let row = tableView.rowControllerAtIndex(i) as? rowController {
                row.contactLabel.setText(contacts as? String)
            }
        }
    }
    
}