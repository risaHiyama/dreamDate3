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

@available(iOS 8.0, *)

class SwiftPlayerManager: NSObject, AVAudioPlayerDelegate{
    
    var name = String()
    
    var player : AVAudioPlayer! = nil
    
    // 初期化処理
    
    override init() {
        
        super.init()
        
        //beachWaves
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("BeachWaves", ofType: "mp3")!)
        
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

@available(iOS 8.0, *)
class ViewController: UIViewController , UITextFieldDelegate {
    
    //受取用プロパティー
    var sleepType = 1
    var usernameParseClass:String = "abc"
    
    var manager : SwiftPlayerManager?
    let myMotionManager = CMMotionManager()
    
    var first_readingX: Double = 0.0
    var second_readingX: Double = 0.2
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
    
    @IBAction func startTimer(sender: AnyObject) {
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("timerStart"), userInfo: nil, repeats: true)
        
        explanation.hidden = true
        timerStart()
        
        if sleepType == 4 {
            self.playMusic()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = SwiftPlayerManager()
    }
    
    //音楽を流し始めるタイミング
    func timerStart(){
        if (self.sleepType == 0 || self.sleepType == 1){
            //            if (count < 60*30){
            //                count++
            //                //print(count)
            //            }
            //            if count ==  60*30 {
            //                readAccelerometer()
            //            }
            
            if (count < 60*30 ){
                count++
                print(count)
            }
            if count == 60*30 {
                readAccelerometer()
                start.hidden = true
            }
        }
        if (self.sleepType==4){
            readAccelerometer()
        }
    }
    
    //テスト用
    //    func timerStart(){
    //        if (count < 5){
    //            count++
    ////            print(count)
    //        }
    //        if count == 5 {
    //            readAccelerometer()
    //            start.hidden = true
    //        }
    //
    //    }
    
    func readAccelerometer(){
        
        myMotionManager.accelerometerUpdateInterval = 1.0
        myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData:CMAccelerometerData?, error:NSError?) -> Void in
            
            if let x = accelerometerData?.acceleration.x {
                self.first_readingX = self.second_readingX
                self.second_readingX = x
                self.differenceX = self.second_readingX -  self.first_readingX
                print("DifferenceX:\(self.differenceX)")
            }
            
            if let y = accelerometerData?.acceleration.y {
                self.first_readingY = self.second_readingY
                self.second_readingY = y
                self.differenceY = self.second_readingY -  self.first_readingY
                print("DifferenceY:\(self.differenceY)")
            }
            
            if let z = accelerometerData?.acceleration.z {
                self.first_readingZ = self.second_readingZ
                self.second_readingZ = z
                self.differenceZ = self.second_readingZ -  self.first_readingZ
                print("DifferenceZ:\(self.differenceZ)")
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
            
            //Parse: send! checking if it's sucessful
            object.saveInBackgroundWithBlock{(success,error)->Void in
                if success == true{
                    //println("Successful")
                }else{
                    print("Failed")
                    print(error)
                }
            }
            
            if ( self.sleepType==0 || self.sleepType==4 ) {
                if ((self.differenceX > 0.1 || self.differenceY >   0.1 ) || self.differenceZ >  0.1 ){
                    self.playMusic()
                }
                
            } else if self.sleepType==1 {
                
                if ((self.differenceY < 0.08 || self.differenceY > 0.07 ) || self.differenceZ > 0.08 ){
                    self.pauseMusic()
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
    
    @IBAction func stop(sender: AnyObject) {
        stopAccelerometerUpdates()
    }
    
    func stopAccelerometerUpdates(){
        self.myMotionManager.stopAccelerometerUpdates()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.pauseMusic()
        stopAccelerometerUpdates()
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

//self.movement = true

//self.music = true

// Send a notification to all devices subscribed to the "Giants" channel.
//                    let push = PFPush()
//
//                    push.setChannel("Giants")
//                    push.setMessage("Satomi is dreaming!")
//                    push.sendPushInBackground()
