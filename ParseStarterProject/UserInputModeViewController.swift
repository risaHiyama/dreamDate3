//
//  UserInputModeViewController.swift
//  ParseStarterProject
//
//  Created by 樋山理紗 on 2015/10/11.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit



class UserInputModeViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? ViewController {
            if let button = sender as? UIButton {
                if button == button1 {
                    viewController.rem = true
                } else if button == button2 {
                    viewController.rem = false
                }
            }
        }
    }
}
