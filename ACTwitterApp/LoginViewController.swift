//
//  ViewController.swift
//  ACTwitterApp
//
//  Created by Adriana Carelli on 26/09/15.
//  Copyright © 2015 Adriana Carelli. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    

    @IBOutlet weak var textEmail: UITextField!
    
    
    @IBOutlet weak var textPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func pressedSignIn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(textEmail.text!, password: textPassword.text!) {
            (user:PFUser?, error:NSError?) -> Void in
            
            if error == nil {
                
                print("logIn")
                self.performSegueWithIdentifier("gotoMainVCFromSigninVC", sender: self)
                
            } else {
                
                print("error")
            }
            
        }
        
    }

    
    
    @IBAction func pressedSignUp(sender: AnyObject) {
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

