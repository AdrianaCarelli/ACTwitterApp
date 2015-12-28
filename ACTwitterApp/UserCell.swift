//
//  UserCell.swift
//  ACTwitterApp
//
//  Created by Adriana Carelli on 26/12/15.
//  Copyright © 2015 Adriana Carelli. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var imageViewProfile: UIImageView!
    
    @IBOutlet weak var labelProfileName: UILabel!
    
    @IBOutlet weak var buttonFollowFollowing: UIButton!
    
    @IBOutlet weak var labelUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pressedFollowFollowing(sender: AnyObject) {
        
        let title = buttonFollowFollowing.titleForState(.Normal)
        
        if title == "Follow" {
            
            let followObj = PFObject(className: "follow")
            
            followObj["user"] = PFUser.currentUser()!.username
            followObj["userToFollow"] = labelUsername.text
            
            followObj.save()
            
            buttonFollowFollowing.setTitle("Following", forState: UIControlState.Normal)
            
            
        } else {
            
            let query = PFQuery(className: "follow")
            
            query.whereKey("user", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("userToFollow", equalTo: labelUsername.text!)
            
            let objects = query.findObjects()
            
            for object in objects! {
                
                object.delete()
                
            }
            
            buttonFollowFollowing.setTitle("Follow", forState: UIControlState.Normal)
            
        }
        

    }
}
