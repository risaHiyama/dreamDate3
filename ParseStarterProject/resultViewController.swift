//
//  resultViewController.swift
//  ParseStarterProject
//
//  Created by 樋山 理紗 on 2015/10/14.
//  Copyright © 2015年 Parse. All rights reserved.
//

import UIKit
import Parse

class resultViewController: UIViewController {
    var sleepType = 1
    
    var dreamed = true
    var dreamRelativeToSound = true
    
    @IBOutlet weak var result: UITextField!
    
    @IBAction func dreamed(sender: AnyObject) {
        dreamed = true

    }
    
    @IBAction func didNotDream(sender: AnyObject) {
        dreamed = false
    }
    
    @IBAction func bad(sender: AnyObject) {
        dreamRelativeToSound = false
    }
    @IBAction func good(sender: AnyObject) {
        dreamRelativeToSound = true
    }
    
    @IBAction func resultEnter(sender: AnyObject) {
        if result.text == "" {
            
            displayAlert("Error in form", message: "文章を入力して下さい")
            
        } else {
            
            //Parse: create a table of acceletometer data
            let object = PFObject(className:"Result")
            
            if let user = PFUser.currentUser(),
                objectID = user.objectId {
                    object["userID"] = objectID
            }
            
            //Parse: setting up variables details
            object["dreamed"] = self.dreamed
            
            object["retativity"] = self.dreamRelativeToSound
        
            object["detail"] = self.result.text
            
//            object["dreamType"] = self.sleepType
            
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        result.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}
