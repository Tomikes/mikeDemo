//
//  menuTableViewCell.swift
//  mikeDemo
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 Tomikes. All rights reserved.
//

import UIKit

class menuTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBOutlet weak var myImage: UIImageView!
   
    func configureForMenuItem(menuItem: NSDictionary) {
        myImage.image = UIImage(named: menuItem["image"] as! String)
        backgroundColor = UIColor(colorArray: menuItem["colors"] as! NSArray)
    }
    
    
    
}
