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
    var contactsAsStringArr: [String] = []
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
            integer = contacts.count
        }
 
        return (integer)
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = self.contactTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! contactCell
        
        if(defaults.dictionaryForKey("contactListInfo") != nil){
            let contactListDict:NSDictionary = defaults.dictionaryForKey("contactListInfo")!
            let contacts = contactListDict.allKeys
            var contactsAsStringArr: [String] = []
            self.contactsAsStringArr = (contacts as? [String])!
            for(var i = 0; i < self.contactsAsStringArr.count; i+=1) {
                cell.nameLabel.text = self.contactsAsStringArr[i]
            }
        }
        
        return(cell)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
       
        let selectedName = self.contactsAsStringArr[indexPath.row]
        self.defaults.setObject(selectedName, forKey: "contactSelection")
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //var cell = self.contactTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! contactCell
        //let selectedName = cell.nameLabel.text
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewControllerWithIdentifier("contactProfileViewController") as! contactProfileViewController
        self.presentViewController(resultViewController, animated:true, completion:nil)
        
        
 
    }
    
}