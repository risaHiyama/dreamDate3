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
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func signUp(sender: AnyObject) {
        if username.text == "" || password.text == ""{
            
            let alert = UIAlertController(title: "error", message:"UsernameとPasswordの設定をして下さい", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake( 0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            
            _ = "please try again later"
            
//            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
//
//                self.activityIndicator.stopAnimating()
//                UIApplication.sharedApplication().endIgnoringInteractionEvents()
//                
//                if error= nil{
//                    //signing up successful
//                } else{
//                    if let errorString = error!.userInfo?["error"] as? NSString{
//                        
//                    }
//                }
            }
            
        }
        
        @IBAction func login(sender: AnyObject) {
        }
        
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
        
}
