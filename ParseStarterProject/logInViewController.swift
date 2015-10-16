//
//  logInViewController.swift
//  ParseStarterProject
//
//  Created by 樋山 理紗 on 2015/10/13.
//  Copyright © 2015年 Parse. All rights reserved.
//

import UIKit
import Parse

@available(iOS 8.0, *)

class logInViewController: UIViewController {
    
    var signupActive = true
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottonButton: UIButton!
    @IBOutlet weak var registeredText: UILabel!
    
    @IBAction func login(sender: AnyObject) {
        
        if signupActive == true {
            
            topButton.setTitle("Log in", forState : UIControlState.Normal)
            
            registeredText.text = "既に登録している"
            
            bottonButton.setTitle("Sign up", forState : UIControlState.Normal)
            
            signupActive = false
            
        } else {
            topButton.setTitle("Sign up", forState : UIControlState.Normal)
            
            registeredText.text = "既に登録している"
            
            bottonButton.setTitle("Log in", forState : UIControlState.Normal)
            
            signupActive = true
            
        }
        
    }
    
    func displayAlert(title: String ,message: String){
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == "" || password.text == ""{
            
            displayAlert("Error in form", message: "Please enter a username and password")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake( 0,0,50,50 ))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "please try again later"
            
            if signupActive == true {
                
                let user = PFUser()
                
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackgroundWithBlock ({
                    (success,error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        
                        //signup successful
                        self.performSegueWithIdentifier("login",sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo ["error"] as? String{
                            
                            errorMessage = errorString
                        
                        }
                        self.displayAlert("Failded Signup", message: errorMessage)
                    }
                    
                })
                
            } else {
                
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block:
                    
                    {(user, error) -> Void in
                        
                        if user != nil{
                            
                            //loged in !
                            self.performSegueWithIdentifier("login",sender: self)
                            
                        } else {
                            
                            if let errorString = error!.userInfo["error"] as? String{
                                
                                errorMessage = errorString
                            }
                            
                            self.displayAlert("Failded Login", message: errorMessage)
                    }
                })
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        username.endEditing(true)
        password.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        if PFUser.currentUser() != nil {
//            self.performSegueWithIdentifier("login", sender: self)
//        }
        
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
    
}
