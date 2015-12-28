//
//  SignUpViewController.swift
//  ACTwitterApp
//
//  Created by Adriana Carelli on 26/09/15.
//  Copyright © 2015 Adriana Carelli. All rights reserved.
//


import UIKit


class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var textEmail: UITextField!
    
    @IBOutlet weak var textPassword: UITextField!
    
    @IBOutlet weak var textProfileName: UITextField!
    
    @IBOutlet weak var buttonAddPhoto: UIButton!
    
    @IBOutlet weak var buttonSignUp: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.image = resizeImage(imageView.image!, newWidth: 100)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func pressedAddPhoto(sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    
    @IBAction func pressedSignUp(sender: AnyObject) {
        
        let user = PFUser()
        
        user.username = textEmail.text
        user.password = textPassword.text
        user["profileName"] = textProfileName.text
        
        
        let imageData = UIImagePNGRepresentation(self.imageView.image!)
        let imageFile = PFFile(name: "profilePhoto.png", data: imageData!)
        
        user["photo"] = imageFile
        
        user.signUpInBackgroundWithBlock {
            (succeeded:Bool, error:NSError?) -> Void in
            
            if error == nil {
                
                print("User Created!")
                
                let followObj = PFObject(className: "follow")
                
                followObj["user"] = PFUser.currentUser()!.username
                followObj["userToFollow"] = PFUser.currentUser()!.username
                
                followObj.save()
                 dispatch_async(dispatch_get_main_queue()) {
                
                    self.performSegueWithIdentifier("gotoMainVCFromSignupVC", sender: self)
                }
                
            }else{
                print("User Not Created!")
            }
            
        }

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let theInfo:NSDictionary = info as NSDictionary
        
        let image = theInfo.objectForKey(UIImagePickerControllerEditedImage) as! UIImage
        
//        imageView.image = image
        imageView.image = resizeImage(image, newWidth: 100)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
       
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
