//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
import CoreMotion
import AVFoundation
import CoreData

var name = String()

class SwiftPlayerManager: NSObject, AVAudioPlayerDelegate{
    
    var player : AVAudioPlayer! = nil
    
    // 初期化処理
    
    override init() {
        
        super.init()
        // 音声ファイルパス取得
        //beachWaves
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("shorebirdsBeach", ofType: "mp3")!)
        
        // プレイヤー準備
        player = AVAudioPlayer(contentsOfURL: audioPath, error: nil)
        player.delegate = self
        player.prepareToPlay()
        player.numberOfLoops=2*10
        
        
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
    
    func playState() -> Bool {
        return player.playing
    }
}


class ViewController: UIViewController , UITextFieldDelegate {
    
    var manager : SwiftPlayerManager?
    let myMotionManager = CMMotionManager()
    
    var first_reading = CMAcceleration(x: 0.0, y: 0.0, z: 0.0)
    var second_reading = CMAcceleration(x: 0.0, y: 0.0, z: 0.0)
    var difference = CMAcceleration(x: 0.0, y: 0.0, z: 0.0)
    
    //var music : Bool = false
    var musicStarted : Bool = false
    
    //var movement : Bool = false
    var timer = NSTimer()
    var count = 0
    
    var rem : Bool = true
    
    @IBOutlet var showDreaming: UIImageView!
    @IBOutlet var userName: UITextField!
    @IBOutlet var enterButton: UIButton!
    @IBOutlet var explanation: UILabel!
    
    @IBAction func userNameEnter(sender: AnyObject) {
        name=userName.text
        enterButton.hidden = true
        userName.hidden = true
        explanation.hidden = true
        self.view.endEditing(true);
    }
    
    override func viewDidLoad() {
        self.userName.delegate = self
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("timerStart"), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
        manager = SwiftPlayerManager()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.pauseMusic()
        myMotionManager.stopAccelerometerUpdates()
    }
    
    //布団に入って３０分待ってから加速度を図り始める
    //    func timerStart(){
    //        if (count < 60*30){
    //            count++
    //            println(count)
    //        }
    //        if count ==  60*30 {
    //            readAccelerometer()
    //        }
    //
    //    }
    
    //テスト用
    func timerStart(){
        count++
        if (count < 10){
            println(count)
        }
        if count ==  10 {
            readAccelerometer()
        }
        let volume = (sin(Float(count/10)) + 1) / 2
        manager?.player.volume = volume
    }
    
    func readAccelerometer(){
        
        myMotionManager.accelerometerUpdateInterval = 1.0
        myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData:CMAccelerometerData!, error:NSError!) -> Void in
            
            let x = accelerometerData.acceleration.x
            self.first_reading.x = self.second_reading.x
            self.second_reading.x = x
            self.difference.x = abs (self.second_reading.x -  self.first_reading.x)
            //println("DifferenceX:\(self.differenceX)")
            
            let y = accelerometerData.acceleration.y
            self.first_reading.y = self.second_reading.y
            self.second_reading.y = y
            self.difference.y = abs (self.second_reading.y -  self.first_reading.y)
            //println("DifferenceY:\(self.differenceY)")
            
            let z = accelerometerData.acceleration.z
            self.first_reading.z = self.second_reading.z
            self.second_reading.z = z
            self.difference.z = abs (self.second_reading.z -  self.first_reading.z)
            //println("DifferenceZ:\(self.differenceZ)")
            
            //Parse: create a table of acceletometer data
            var accelerometer = PFObject(className: "Data")
            
            if let user = PFUser.currentUser(),
                objectID = user.objectId {
                    accelerometer["userID"] = objectID
            }
            
            //Parse: setting up variables details
            accelerometer["name"] = name
            accelerometer["DifferenceX"]=self.difference.x
            accelerometer["DifferenceY"]=self.difference.y
            accelerometer["DifferenceZ"]=self.difference.z
            accelerometer["REM"]=self.rem
            
            //Parse: send! checking if it's sucessful
            accelerometer.saveInBackgroundWithBlock{(success,error)->Void in
                if success == true{
                    //println("Successful")
                }else{
                    println("Failed")
                    println(error)
                }
            }
            
            if ((self.difference.x > 0.1 || self.difference.y > 0.1 ) || self.difference.z > 0.1 ){
                
                
                //self.movement = true
                
                //self.music = true
                
                // Send a notification to all devices subscribed to the "Giants" channel.
                //                    let push = PFPush()
                //
                //                    push.setChannel("Giants")
                //                    push.setMessage("Satomi is dreaming!")
                //                    push.sendPushInBackground()
                
                if self.rem == true {
                    self.playMusic()
                }
                
                //accelerometer["moved"]=self.movement
                //println("moved")
            }
            else{
                if self.rem == false {
                    self.playMusic()
                }
            }
            
            if (self.manager!.playState()) {
                accelerometer["music"]=self.manager!.playState()
                self.showDreaming.image=UIImage(named: "musicOn.png")
            } else {
                accelerometer["music"]=self.manager!.playState()
                self.showDreaming.image=UIImage(named: "backGroundStar.png")
            }
        })
    }
    
    
    func playMusic(){
        self.manager!.playOrPause()
    }
    
    func pauseMusic(){
        self.manager!.stopMusic()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
