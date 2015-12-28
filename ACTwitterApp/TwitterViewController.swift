//
//  TwitterViewController.swift
//  ACTwitterApp
//
//  Created by Adriana Carelli on 26/12/15.
//  Copyright © 2015 Adriana Carelli. All rights reserved.
//

import UIKit

class TwitterViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var textTwett: UITextView!
    
    @IBOutlet weak var label90char: UILabel!
    
    @IBOutlet weak var imageViewTwett: UIImageView!
    
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var buttonTwett: UIButton!
    
    @IBOutlet weak var buttonAddPhoto: UIButton!
    
      var hasImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func pressedCancel(sender: AnyObject) {
        
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func pressedTwett(sender: AnyObject) {
        
        var theTweet = textTwett.text
        let len = textTwett.text.characters.count
        //var len = messageTxt.text.utf16Count
        
        if len > 90 {
            
            theTweet = theTweet.substringToIndex(theTweet.startIndex.advancedBy(90))
            
        }
        
        
        let tweetObj = PFObject(className: "tweets")
        
        tweetObj["userName"] = PFUser.currentUser()!.username
        tweetObj["profileName"] = PFUser.currentUser()!.valueForKey("profileName") as! String
        tweetObj["photo"] = PFUser.currentUser()!.valueForKey("photo") as! PFFile
        tweetObj["tweet"] = theTweet
        
        if hasImage == true {
            
            tweetObj["hasImage"] = "yes"
            
            let imageData = UIImagePNGRepresentation(self.imageViewTwett.image!)
            let imageFile = PFFile(name: "tweetPhoto.png", data: imageData!)
            tweetObj["tweetImage"] = imageFile
            
        } else {
            
            tweetObj["hasImage"] = "no"
            
        }
        
        
        tweetObj.save()
        
        print("tweet!")
//         dispatch_async(dispatch_get_main_queue()) {
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
    }

    @IBAction func pressedAddPhoto(sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let len = textTwett.text.characters.count
        //let len = count(messageTxt.text.utf16)
        //var len = messageTxt.text.utf16Count
        let diff = 90 - len
        
        if diff < 0 {
            
            label90char.textColor = UIColor.redColor()
        } else {
            
            label90char.textColor = UIColor.blackColor()
        }
        
        label90char.text = "\(diff) chars left"
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let theInfo:NSDictionary = info as NSDictionary
        
        let image:UIImage = theInfo.objectForKey(UIImagePickerControllerEditedImage) as! UIImage
        imageViewTwett.image = image
        
        hasImage = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


}
