//
//  sleepTimerStartViewController.swift
//  ParseStarterProject
//
//  Created by 樋山理紗 on 2015/10/16.
//  Copyright © 2015年 Parse. All rights reserved.
//

import UIKit
import AVFoundation

class SwiftPlayerManager2: NSObject, AVAudioPlayerDelegate{
    
    var player : AVAudioPlayer! = nil
    
    override init() {
        
        super.init()
        // 音声ファイルパス取得
        //beachWaves
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("AllAroundTheWorld", ofType: "mp3")!)
        
        // プレイヤー準備
        player = try? AVAudioPlayer(contentsOfURL: audioPath)
        player.delegate = self
        player.prepareToPlay()
        player.numberOfLoops=2*10
    
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

class sleepTimerStartViewController: UIViewController {
    
    //パラメータ受取用プロパティ、sleepDurationInputの初期値を与える
    var sleepDurationInput: String = "abc"
    
    var timer = NSTimer()
    var count = 0
    var manager : SwiftPlayerManager?

    //この画面のsleepDurationラベル
    @IBOutlet var sleepDuration: UILabel!
    
    @IBAction func start(sender: AnyObject) {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("timerStart"), userInfo: nil, repeats: true)
        
        timerStart()
        
        //一回しかおせないようにする
        let disableMyButton = sender as? UIButton
        disableMyButton!.enabled = false
        
    }
    
    func timerStart() {
        
        count++
        
        print(count)
        
        //sleepTime（音を鳴らすまでにタイマーが数える秒数）に前のページに書き込んだ数値sleepDurationをもとに計算
        let sleepingTime : Int? = (Int(sleepDuration.text!)!-1)*60*60
        
        //print(sleepingTime!)
        
        if sleepingTime < count {
            self.playMusic()
        }
    }
    
    func playMusic(){
        self.manager!.playOrPause()
    }
    
    func pauseMusic(){
        self.manager!.stopMusic()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = SwiftPlayerManager()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    override func viewDidAppear(animated: Bool) {
        //この画面のラベルsleepDurationにこのページのsleepDurationInputを代入
        self.sleepDuration.text = sleepDurationInput
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        sleepDuration.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

   
}
