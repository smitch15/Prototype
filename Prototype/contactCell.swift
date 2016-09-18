//
//  contactCell.swift
//  Prototype
//
//  Created by Anthony Parente on 9/2/16.
//  Copyright © 2016 Anthony Parente. All rights reserved.
//

import UIKit

class contactCell: UITableViewCell {

    @IBOutlet weak var nameButton: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func entersInfoForSegue(sender: AnyObject) {
        var selectedName: String = self.nameButton.currentTitle!
        self.defaults.setObject(selectedName, forKey: "contactSelection")
        print(selectedName)
    }
}
