//
//  MainViewController.swift
//  ACTwitterApp
//
//  Created by Adriana Carelli on 26/12/15.
//  Copyright © 2015 Adriana Carelli. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var followArray = [String]()
    
    var resultsNameArray = [String]()
    var resulltsImageFiles = [PFFile]()
    var resultsTweetArray = [String]()
    var resultsHasImageArray = [String]()
    var resultsTweetImageFiles = [PFFile?]()
    
    var refresher:UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tweetBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: Selector("tweetBtn_click"))
        
        let searchBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("searchBtn_click"))
        
        let buttonArray = NSArray(objects: tweetBtn, searchBtn)
        self.navigationItem.rightBarButtonItems = buttonArray as? [UIBarButtonItem]
        
//        refresher = UIRefreshControl()
//        refresher.tintColor = UIColor.blackColor()
//        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        self.tableView.addSubview(refresher)
        
       

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func refresh() {
        
        print("refresh table")
        
        refreshResults()
        
    }
    
    func refreshResults() {
        
        followArray.removeAll(keepCapacity: false)
        resultsNameArray.removeAll(keepCapacity: false)
        resulltsImageFiles.removeAll(keepCapacity: false)
        resultsTweetArray.removeAll(keepCapacity: false)
        resultsHasImageArray.removeAll(keepCapacity: false)
        resultsTweetImageFiles.removeAll(keepCapacity: false)
        
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("user", equalTo: PFUser.currentUser()!.username!)
        followQuery.addDescendingOrder("createdAt")
        
        let objects = followQuery.findObjects()
        
        for object in objects! {
            
            self.followArray.append(object.objectForKey("userToFollow") as! String)
            
        }
        
        let query = PFQuery(className: "tweets")
        query.whereKey("userName", containedIn: followArray)
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]?, error:NSError?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    
                    self.resultsNameArray.append(object.objectForKey("profileName") as! String)
                    self.resulltsImageFiles.append(object.objectForKey("photo") as! PFFile)
                    self.resultsTweetArray.append(object.objectForKey("tweet") as! String)
                    self.resultsHasImageArray.append(object.objectForKey("hasImage") as! String)
                    self.resultsTweetImageFiles.append(object.objectForKey("tweetImage") as? PFFile)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
                
//              self.refresher.endRefreshing()
                
            }
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        

        refreshResults()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }
    
    func tweetBtn_click() {
        
        print("tweet pressed")
        
        self.performSegueWithIdentifier("gotoTweetVCFromMainVC", sender: self)
        
    }
    
    func searchBtn_click() {
        
        print("search pressed")
        self.performSegueWithIdentifier("gotoUsersVCFromMainVC", sender: self)
        
    }
    
    @IBAction func logoutBtn(sender: AnyObject) {
        
        PFUser.logOut()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsNameArray.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if resultsHasImageArray[indexPath.row] == "yes" {
            
           //return self.view.frame.size.width - 10
           return 350
            
        } else {
            
            
            return 90
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MainCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MainCell
        
        cell.imgTwett.hidden = true
        cell.textMessage.editable=false;
        
        cell.labelProfileName.text = self.resultsNameArray[indexPath.row]
        cell.textMessage.text = self.resultsTweetArray[indexPath.row]
        
        resulltsImageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (imageData:NSData?, error:NSError?) -> Void in
            
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.imgView.image = image
                
            }
            
        }
        
        if resultsHasImageArray[indexPath.row] == "yes" {
            
            
            
           
            cell.imgTwett.hidden = false
            
            resultsTweetImageFiles[indexPath.row]?.getDataInBackgroundWithBlock({
                (imageData:NSData?, error:NSError?) -> Void in
                
                if error == nil {
                    
                    let image = UIImage(data: imageData!)
                    cell.imgTwett.image = image
                    
                }
                
            })
            
        }
        
        return cell
        
    }



}
