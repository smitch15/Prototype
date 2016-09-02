//
//  regularViewController.swift
//  Prototype
//
//  Created by Anthony Parente on 8/29/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

import UIKit

class regularViewController: UIViewController{
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        self.isAppAlreadyLaunchedOnce()
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        
        if(NSUserDefaults.standardUserDefaults().stringForKey("isAppAlreadyLaunchedOnce") != nil){
            print("App already launched")
            
            return true
        }else{
            // above call to function would instatiate the view controller that contains the tutorial video along with the prompt to enter personal info
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let resultViewController = storyBoard.instantiateViewControllerWithIdentifier("firstLaunchViewController") as! firstLaunchViewController
            
            self.presentViewController(resultViewController, animated:true, completion:nil)
            return false
        }
    }



}