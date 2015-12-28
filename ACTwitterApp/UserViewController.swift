//
//  UserViewController.swift
//  ACTwitterApp
//
//  Created by Adriana Carelli on 26/12/15.
//  Copyright © 2015 Adriana Carelli. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var resultsNameArray = [String]()
    var resultsUserNameArray = [String]()
    var resultsImageFiles = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidAppear(animated: Bool) {
        
        
        resultsNameArray.removeAll(keepCapacity: false)
        resultsUserNameArray.removeAll(keepCapacity: false)
        resultsImageFiles.removeAll(keepCapacity: false)
        
        let query = PFUser.query()
        
        query!.whereKey("username", notEqualTo: PFUser.currentUser()!.username!)
        
        query!.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]?, error:NSError?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    
                    self.resultsNameArray.append(object.objectForKey("profileName") as! String)
                    self.resultsImageFiles.append(object.objectForKey("photo") as! PFFile)
                    self.resultsUserNameArray.append(object.objectForKey("username") as! String)
                    
                    self.tableView.reloadData()
                    
                    
                }
                
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsNameArray.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 64
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UserCell = tableView.dequeueReusableCellWithIdentifier("CellUser") as! UserCell
        
        cell.labelProfileName.text = self.resultsNameArray[indexPath.row]
        cell.labelUsername.text = self.resultsUserNameArray[indexPath.row]
        
        let query = PFQuery(className: "follow")
        
        query.whereKey("user", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("userToFollow", equalTo: cell.labelUsername.text!)
        
        query.countObjectsInBackgroundWithBlock {
            (count:Int32, error:NSError?) -> Void in
            
            if error == nil {
                
                if count == 0 {
                    
                    cell.buttonFollowFollowing .setTitle("Follow", forState: UIControlState.Normal)
                    
                } else {
                    
                    cell.buttonFollowFollowing.setTitle("Following", forState: UIControlState.Normal)
                }
                
            }
            
        }
        
        
        self.resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (imageData:NSData?, error:NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.imageViewProfile.image = image
                
            }
            
        }
        
        return cell
        
    }



}
