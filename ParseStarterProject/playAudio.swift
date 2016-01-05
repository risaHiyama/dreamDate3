//
//  playAudio.swift
//  DreamDate
//
//  Created by 樋山理紗 on 2016/01/05.
//  Copyright © 2016年 Parse. All rights reserved.
//

import UIKit
import AVFoundation

class playAudio: NSObject ,AVAudioPlayerDelegate{
    var player : AVAudioPlayer! = nil   // プレイヤー
    
    // 初期化処理
    override init() {
        super.init()
        
        // 音声ファイルパス取得
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("AllAroundTheWorld", ofType: "mp3")!)
        
        // プレイヤー準備
        player = try? AVAudioPlayer(contentsOfURL: audioPath)
        player.delegate = self
        player.prepareToPlay()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 再生／一時停止処理
    func playOrPause() {
        if (player.playing) {
            // 現在再生中なら一時停止
            player.pause()
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
}

class playAudioViewController: ViewController {
    var manager2: playAudio?
    
    @IBOutlet weak var buttonPlayPauseMusic: UIButton!
    
    @IBAction func playMusic(sender: AnyObject) {
        manager2!.playOrPause()
        
        // 再生／一時停止ボタン表示切り替え
        if (manager!.player.playing) {
            // 再生中なら「Pause」表示
            buttonPlayPauseMusic!.setTitle("Pause",
            forState: UIControlState.Normal)
        } else {
            // 再生していないなら「Play」表示
            buttonPlayPauseMusic!.setTitle("Play",
                forState: UIControlState.Normal)
        }
    }
    // 再生終了通知検知時処理
    func audioStopAction() {
        // 「Play」表示に戻す
        buttonPlayPauseMusic!.setTitle("Play", forState: UIControlState.Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 再生管理クラス生成
        manager2 = playAudio()
        
        // 再生終了通知を監視
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "audioStopAction", name: "stop", object: nil)
        
        func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }



}
