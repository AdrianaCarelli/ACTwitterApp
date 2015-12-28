//
//  MainCell.swift
//  ACTwitterApp
//
//  Created by Adriana Carelli on 26/12/15.
//  Copyright © 2015 Adriana Carelli. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {
    
    @IBOutlet weak var textMessage: UITextView!
    
    
    @IBOutlet weak var labelProfileName: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var imgTwett: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        



    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
