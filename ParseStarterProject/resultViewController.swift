//
//  resultViewController.swift
//  ParseStarterProject
//
//  Created by 樋山 理紗 on 2015/10/14.
//  Copyright © 2015年 Parse. All rights reserved.
//

import UIKit
import Parse

@available(iOS 8.0, *)

class resultViewController: UIViewController {
    
    @IBOutlet weak var result: UITextField!
    
    @IBAction func resultEnter(sender: AnyObject) {
        if result.text == "" {
            
            displayAlert("Error in form", message: "文章を入力して下さい")
            
        } else {
            
            //Parse: create a table of acceletometer data
            let object = PFObject(className:"Dream")
            
            if let user = PFUser.currentUser(),
                objectID = user.objectId {
                    object["userID"] = objectID
            }
            
            //Parse: setting up variables details
            object["result"] = self.result.text
            
            //Parse: send! checking if it's sucessful
            object.saveInBackgroundWithBlock{(success,error)->Void in
                if success == true{
                    //println("Successful")
                }else{
                    print("Failed")
                    print(error)
                }
            }

            
        }
    }
    
    
    
    func displayAlert(title: String ,message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
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
