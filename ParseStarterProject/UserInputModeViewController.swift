//
//  UserInputModeViewController.swift
//  ParseStarterProject
//
//  Created by 樋山理紗 on 2015/10/11.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit
import Parse

class UserInputModeViewController: UIViewController {
    
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let object = PFObject(className:"DreamType")
        
        if let user = PFUser.currentUser(),
            objectID = user.objectId {
                object["userID"] = objectID
        }
        
        if let viewController = segue.destinationViewController as? ViewController {
            print(sender)
            if let button = sender as? UIButton {
                // 0=REM
                // 1=nonREM
                // 2=timer
                // 3=beforeSleeping
                
                print(button)
                
                if button == button0 {
                    
                    object["dreamType"] = 0
                    
                } else if button == button1 {
                    
                    viewController.sleepType = 0
                    
                    object["dreamType"] = 1
                    
                } else if button == button2 {
                    
                    viewController.sleepType = 1
                    
                    object["dreamType"] = 2
                    
                } else if button == button3 {
                    
                    object["dreamType"] = 3
                    
                } else if button == button4 {
                    
                    object["dreamType"] = 4
                    
                    viewController.sleepType = 4
                }
                
            }
        }
        
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
