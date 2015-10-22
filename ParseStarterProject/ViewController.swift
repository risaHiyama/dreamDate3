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

class SwiftPlayerManager: NSObject, AVAudioPlayerDelegate{
    
    var name = String()
    
    var player : AVAudioPlayer! = nil
    
    // 初期化処理
    
    override init() {
        
        super.init()
        // 音声ファイルパス取得
        //beachWaves
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("shorebirdsBeach", ofType: "mp3")!)
        
        // プレイヤー準備
        player = try? AVAudioPlayer(contentsOfURL: audioPath)
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
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
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
    
    //受取用プロパティー
    var sleepType = 1
    var usernameParseClass:String = "abc"

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
    
    //var music : Bool = false
    var musicStarted : Bool = false
    
    //var movement : Bool = false
    var timer = NSTimer()
    var count = 0
    
    @IBOutlet var explanation: UILabel!
    
    @IBOutlet var userInfo: UITextField!
    
    //開始後画像入れ替えするため
    @IBOutlet var showDreaming: UIImageView!
    
    @IBOutlet weak var start: UIButton!
    
    @IBAction func startMonitoring(sender: AnyObject) {
        timerStart()
        explanation.hidden = true
    }
    
    override func viewDidLoad() {
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("timerStart"), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
        manager = SwiftPlayerManager()
    }
    
    //布団に入って３０分待ってから加速度を図り始める
//                func timerStart(){
//                    if (count < 60*30){
//                        count++
//                        //print(count)
//                    }
//                    if count ==  60*30 {
//                        readAccelerometer()
//                    }
//    
//                }

    //テスト用
    func timerStart(){
        if (count < 5){
            count++
//            print(count)
        }
        if count == 5 {
            readAccelerometer()
            start.hidden = true
        }
        
    }

    func readAccelerometer(){

        myMotionManager.accelerometerUpdateInterval = 1.0
        myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData:CMAccelerometerData?, error:NSError?) -> Void in
            
            if let x = accelerometerData?.acceleration.x {
                self.first_readingX = self.second_readingX
                self.second_readingX = x
                self.differenceX = abs (self.second_readingX -  self.first_readingX)
                //println("DifferenceX:\(self.differenceX)")
            }
            
            if let y = accelerometerData?.acceleration.y {
                self.first_readingY = self.second_readingY
                self.second_readingY = y
                self.differenceY = abs (self.second_readingY -  self.first_readingY)
                //println("DifferenceY:\(self.differenceY)")
            }
            
            if let z = accelerometerData?.acceleration.z {
                self.first_readingZ = self.second_readingZ
                self.second_readingZ = z
                self.differenceZ = abs (self.second_readingZ -  self.first_readingZ)
                //println("DifferenceZ:\(self.differenceZ)")
            }
            
            //Parse: create a table of acceletometer data
            let object = PFObject(className:self.userInfo.text!)
            
            if let user = PFUser.currentUser(),
                objectID = user.objectId {
                    object["userID"] = objectID
            }
            
            //Parse: setting up variables details
            object["DifferenceX"]=self.differenceX
            object["DifferenceY"]=self.differenceY
            object["DifferenceZ"]=self.differenceZ
            object["SleepType"]=self.sleepType
            object["username"]=self.usernameParseClass
            
            //Parse: send! checking if it's sucessful
            object.saveInBackgroundWithBlock{(success,error)->Void in
                if success == true{
                    //println("Successful")
                }else{
                    print("Failed")
                    print(error)
                }
            }
            
            if ((self.differenceX > 0.1 || self.differenceY > 0.1 ) || self.differenceZ > 0.1 ){
                
                //self.movement = true
                
                //self.music = true
                
                // Send a notification to all devices subscribed to the "Giants" channel.
                //                    let push = PFPush()
                //
                //                    push.setChannel("Giants")
                //                    push.setMessage("Satomi is dreaming!")
                //                    push.sendPushInBackground()
                
                if self.sleepType == 0 {
                    self.playMusic()
                }
                
                //accelerometer["moved"]=self.movement
                //println("moved")
            }
            else{
                if self.sleepType == 1 {
                    self.playMusic()
                }
            }
            
            if (self.manager!.playState()) {
                object["music"]=self.manager!.playState()
                self.showDreaming.image=UIImage(named: "musicOn.png")
            } else {
                object["music"]=self.manager!.playState()
                self.showDreaming.image=UIImage(named: "backGroundStar.png")
            }
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.pauseMusic()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userInfo.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
