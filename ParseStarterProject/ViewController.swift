//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import CoreData

class SwiftPlayerManager: NSObject, AVAudioPlayerDelegate{
    
    var name = String()
    var player : AVAudioPlayer! = nil
    
    // 初期化処理
    override init() {
        
        super.init()
        
        //beachWaves
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("AllAroundTheWorld", ofType: "mp3")!)
        
        // プレイヤー準備
        player = try? AVAudioPlayer(contentsOfURL: audioPath)
        player.delegate = self
        player.prepareToPlay()
        player.numberOfLoops=30
    
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
    
    var first_readingY: Double = 0.0
    var second_readingY: Double = 0.0
    
    var first_readingZ: Double = 0.0
    var second_readingZ: Double = 0.0
    
    var status:Status = .NonRem
    
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
        start.hidden = true
        
        timerStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = SwiftPlayerManager()
    }
    
    //音楽を流し始めるタイミング、選んだボタンによって違う動きをする
    func timerStart(){
        if  ( count < Settings.timeWaitingForUserToSleep ) {
            count++
            print(count)
        }
        if ( count == Settings.timeWaitingForUserToSleep ) {
            readAccelerometer()
        }
    }
    
    func readAccelerometer(){
        
        myMotionManager.accelerometerUpdateInterval = 1.0
        myMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(accelerometerData:CMAccelerometerData?, error:NSError?) -> Void in
            
            var differenceX: Double = 0.0
            var differenceY: Double = 0.0
            var differenceZ: Double = 0.0
            
            if let x = accelerometerData?.acceleration.x {
                self.first_readingX = self.second_readingX
                self.second_readingX = x
                differenceX = self.second_readingX -  self.first_readingX
            }
            
            if let y = accelerometerData?.acceleration.y {
                self.first_readingY = self.second_readingY
                self.second_readingY = y
                differenceY = self.second_readingY -  self.first_readingY
            }
            
            if let z = accelerometerData?.acceleration.z {
                self.first_readingZ = self.second_readingZ
                self.second_readingZ = z
                differenceZ = self.second_readingZ -  self.first_readingZ
            }
            
            let beingChageStatus = Motion.sharedInstance.addMotion(differenceX, differenceY, differenceZ)
            
            // レム／ノンレムの切り替え
            if beingChageStatus {
                if self.status == .NonRem {
                    self.status = .Rem
                    // 音楽を流す
                    self.playMusic()
                } else {
                    self.status = .NonRem
                    // 音楽を止める
                    self.pauseMusic()
                }
            }
            
        
            if (self.manager!.playState()) {
                self.showDreaming.image=UIImage(named: "musicOn.png")
            } else {
                self.showDreaming.image=UIImage(named: "backGroundStar.png")
            }
            
            // Parseに保存
            Motion.sharedInstance.saveToParse(self.userInfo.text!, musicStatus: self.manager!.playState())
            
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