//
//  userFeedbackViewController.swift
//  ParseStarterProject
//
//  Created by 樋山理紗 on 2015/10/13.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit
import Parse

class userFeedbackViewController: UIViewController {
    
    //Parse: create a table of acceletometer data
//    var comment = PFObject(className: "Dream")
//    
//    comment["userFeedback"] = userFeedback.text
    
    @IBOutlet var userFeedback: UITextField!
    
    @IBAction func userInput(sender: AnyObject) {
        //userFeedback.textをpartse class Dreamに送る
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
