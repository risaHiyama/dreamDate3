//
//  timerSetViewController.swift
//  ParseStarterProject
//
//  Created by 樋山 理紗 on 2015/10/15.
//  Copyright © 2015年 Parse. All rights reserved.
//

import UIKit

class inputSleepingTime: UIViewController {
    
    //userInputにユーザーが時間を書き込む
    @IBOutlet var userInput: UITextField!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? sleepTimerStartViewController {
            //userInputがviewContollerのsleepDurationInputに送られる
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
}
