//
//  contactListView.swift
//  Prototype
//
//  Created by Anthony Parente on 8/31/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

import UIKit

class contactListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var contactTableView: UITableView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var integer: Int = 0
        
        if(defaults.dictionaryForKey("contactListInfo") != nil){
            let contactListDict:NSDictionary = defaults.dictionaryForKey("contactListInfo")!
            let contacts = contactListDict.allKeys
            var contactsAsStringArr: [String] = []
            contactsAsStringArr = (contacts as? [String])!
            integer = contactsAsStringArr.count
        }
 
        return (integer)
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = self.contactTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! contactCell
        
        return(cell)
    }
    
    

}