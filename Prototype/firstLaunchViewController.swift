//
//  ViewController.swift
//  Prototype
//
//  Created by Anthony Parente on 8/2/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

import UIKit

class firstLaunchViewController: UIViewController {
    
    @IBOutlet weak var f_NameText: UITextField!
    @IBOutlet weak var L_NameText: UITextField!
    @IBOutlet weak var eduText: UITextField!
    @IBOutlet weak var companyText: UITextField!
    @IBOutlet weak var positionText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func personalInfoSubmitted(sender: AnyObject) {
        
        let fName = f_NameText.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let lName = L_NameText.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let edu = eduText.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let company = companyText.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let position = positionText.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let email = emailText.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        defaults.setObject(fName, forKey: "userFirstName")
        defaults.setObject(lName, forKey: "userLastName")
        defaults.setObject(edu, forKey: "userEducation")
        defaults.setObject(company, forKey: "userCompanyName")
        defaults.setObject(position, forKey: "userOccupation")
        defaults.setObject(email, forKey: "userEmail")
        
        
    }
      
    
    
}
