//
//  timerSetViewController.swift
//  ParseStarterProject
//
//  Created by 樋山 理紗 on 2015/10/15.
//  Copyright © 2015年 Parse. All rights reserved.
//

import UIKit

class timerSetViewController: UIViewController {
    
    var timer = NSTimer()
    
    var count = 0
    
    func updateTime() {
        
        count++
        print(count)
        //time.text = "\(count)"
        
    }
    
    
    @IBOutlet weak var sleepDuration: UITextField!
    
    @IBAction func enter(sender: AnyObject) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        // sleepDuration * 60
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
