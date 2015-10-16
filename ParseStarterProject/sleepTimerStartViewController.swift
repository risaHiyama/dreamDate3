//
//  sleepTimerStartViewController.swift
//  ParseStarterProject
//
//  Created by 樋山理紗 on 2015/10/16.
//  Copyright © 2015年 Parse. All rights reserved.
//

import UIKit

class sleepTimerStartViewController: UIViewController {
    
    var timer = NSTimer()
    var count = 0
    
    @IBAction func start(sender: AnyObject) {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("timerStart"), userInfo: nil, repeats: true)
        
        timerStart()
        
    }
    
    func timerStart() {
        
        
        
        count++
        
        print(count)
        
        
        
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
