//
//  contactProfileViewController.swift
//  Prototype
//
//  Created by Anthony Parente on 9/7/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

import UIKit

class contactProfileViewController: UIViewController{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var occLabel: UILabel!
    @IBOutlet weak var eduLabel: UILabel!
    @IBOutlet weak var TP1: UILabel!
    @IBOutlet weak var TP2: UILabel!
    @IBOutlet weak var TP3: UILabel!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.displayProf()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   // override func viewDidAppear(animated: Bool) {
        
   // }
    
    func displayProf(){
        let keyForProfInfo = self.defaults.stringForKey("contactSelection")!
        let contactListInfo = self.defaults.dictionaryForKey("contactListInfo")
        let dictionaryOfInfo = contactListInfo![keyForProfInfo]!
        self.nameLabel.text = keyForProfInfo
        self.occLabel.text = dictionaryOfInfo["occ"] as! String
        self.eduLabel.text = dictionaryOfInfo["edu"] as! String
        self.TP1.text = dictionaryOfInfo["int1"] as! String
    }

}