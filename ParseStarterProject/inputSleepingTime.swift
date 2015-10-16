//
//  timerSetViewController.swift
//  ParseStarterProject
//
//  Created by 樋山 理紗 on 2015/10/15.
//  Copyright © 2015年 Parse. All rights reserved.
//

import UIKit

class inputSleepingTime: UIViewController {
    
    @IBOutlet var userInput: UITextField!

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let viewController = segue.destinationViewController as? sleepTimerStartViewController {
                viewController.sleepDurationInput = userInput.text!
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //パラメータのバインド
        //self.userInput.text = self.sleepDurationInput
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
