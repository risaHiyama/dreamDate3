//
//  nonRemViewController.swift
//  ParseStarterProject
//
//  Created by 樋山理紗 on 2015/10/06.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit
import Parse
import CoreMotion
import AVFoundation
import CoreData


class playerManager: NSObject, AVAudioPlayerDelegate{
    
    var player : AVAudioPlayer! = nil
    // 初期化処理
    override init() {
        
        super.init()
        // 音声ファイルパス取得
        //beachWaves
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("BeachWaves", ofType: "mp3")!)
        
        // プレイヤー準備
        player = AVAudioPlayer(contentsOfURL: audioPath, error: nil)
        player.delegate = self
        player.prepareToPlay()
//        player.numberOfLoops=2*20
        
        
        // When users indicate they are Giants fans, we subscribe them to that channel.
        //            let currentInstallation = PFInstallation.currentInstallation()
        //            currentInstallation.addUniqueObject("Giants", forKey: "channels")
        //            currentInstallation.saveInBackground()
        
    }
    
    func playOrPause() {
        if (player.playing) {
        } else {
            // 現在再生していないなら再生
            player.play()
        }
    }
    
    // 再生終了時処理
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        player.stop()
        
        // 再生終了を通知
        let noti = NSNotification(name: "stop", object: self)
        NSNotificationCenter.defaultCenter().postNotification(noti)
    }
    
    func stopMusic() {
        if (player.playing) {
            player.stop()
        }
    }
}

class nonRemViewController: UIViewController , UITextFieldDelegate  {

    var manager : SwiftPlayerManager?
    let myMotionManager = CMMotionManager()
    
    var first_readingX: Double = 0.0
    var second_readingX: Double = 0.0
    var differenceX: Double = 0.0
    
    var first_readingY: Double = 0.0
    var second_readingY: Double = 0.0
    var differenceY: Double = 0.0
    
    var first_readingZ: Double = 0.0
    var second_readingZ: Double = -1.0
    var differenceZ: Double = 0.0
    
    var music : Bool = false
    var musicIsPlaying : Bool = false
    
    var movement : Bool = false
    var timer = NSTimer()
    var count = 0
    
    var rem : Bool = false
    
    @IBOutlet var showDreaming: UIImageView!
    let notDreaming = UIImage(named: "images/backGroundStar.png")
    let dreaming = UIImage(named: "images/musicOn.png")

    @IBOutlet var userName: UITextField!
    @IBOutlet var usernameEnter: UIButton!
    @IBAction func userNameEnter(sender: AnyObject) {
        name=userName.text
        usernameEnter.hidden = true
        userName.hidden = true
        self.view.endEditing(true);
    }
    
    override func viewDidLoad() {
        self.userName.delegate = self
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("timerStart"), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
        manager = SwiftPlayerManager()
        
    }
    
    func timerStart(){
        if (count < 6){
            count++
            println(count)
        }
        if count ==  6 {
            readAccelerometer()
        }
        
    }
    
    func readAccelerometer(){
    
        myMotionManager.accelerometerUpdateInterval = 1.0
        
        myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData:CMAccelerometerData!, error:NSError!) -> Void in
            
            let x = accelerometerData.acceleration.x
            self.first_readingX = self.second_readingX
            self.second_readingX = x
            self.differenceX = abs (self.second_readingX -  self.first_readingX)
            println("DifferenceX:\(self.differenceX)")
            
            let y = accelerometerData.acceleration.y
            self.first_readingY = self.second_readingY
            self.second_readingY = y
            self.differenceY = abs (self.second_readingY -  self.first_readingY)
            println("DifferenceY:\(self.differenceY)")
            
            let z = accelerometerData.acceleration.z
            self.first_readingZ = self.second_readingZ
            self.second_readingZ = z
            self.differenceZ = abs (self.second_readingZ -  self.first_readingZ)
            println("DifferenceZ:\(self.differenceZ)")
    
            //Parse: create a table of acceletometer data
            var accelerometer = PFObject(className: "RisaPhone")
            
            //Parse: setting up variables details
            accelerometer["DifferenceX"]=self.differenceX
            accelerometer["DifferenceY"]=self.differenceY
            accelerometer["DifferenceZ"]=self.differenceZ
            accelerometer["REM"]=self.rem
            
            //Parse: send! checking if it's sucessful
            accelerometer.saveInBackgroundWithBlock{(success,error)->Void in
                if success == true{
                    println("Successful")
                }else{
                    println("Failed")
                    println(error)
                }
            }
            
            if ((self.differenceX < 0.1 || self.differenceY < 0.1 ) || self.differenceZ < 0.1 ){
                self.movement = true

                self.music = true

                // Send a notification to all devices subscribed to the "Giants" channel.
//                let push = PFPush()
//                push.setChannel("Giants")
//                push.setMessage("Satomi is dreaming!")
//                push.sendPushInBackground()
                self.playMusic()
                
                //accelerometer["moved"]=self.movement
                self.musicIsPlaying = true
            }

            else{
                self.music = false
                self.movement = false
                self.musicIsPlaying = false
            }

            if (self.musicIsPlaying) {
                self.showDreaming.image=UIImage(named: "musicOn.png")
            } else {
                self.showDreaming.image=UIImage(named: "backGroundStar.png")
            }
        })
    }

    
    func playMusic(){
        musicIsPlaying = true
        self.manager!.playOrPause()
    }
    
    
    func pauseMusic(){
        self.musicIsPlaying = false
        self.manager!.stopMusic()
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
