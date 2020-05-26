//
//  HomeTableViewCell.swift
//  Dabble
//
//  Created by Dineshbabu on 29/08/15.
//  Copyright (c) 2015 Saxon Global Inc. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell

{
    @IBOutlet var JobDes: UITextView!

    
    @IBOutlet var jobPoster: UIImageView!
    @IBOutlet var jobTitle: UILabel!
    @IBOutlet var jobDistance: UIButton!
    @IBOutlet var jobDistanceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        jobPoster.layer.cornerRadius = 5.0
//        jobPoster.layer.borderColor = appGraycolor.CGColor
//        jobPoster.layer.masksToBounds = true
//        jobPoster.layer
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
