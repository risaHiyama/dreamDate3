//
//  Motion.swift
//  ParseStarterProject
//
//  Created by 樋山理紗 on 2015/11/03.
//  Copyright © 2015年 Parse. All rights reserved.
//

import Foundation
import Parse

class Motion {

    static let sharedInstance = Motion()

    /// 計測したデータの合計数
    var allMotionLength = 0
    var index = 0
    
    var motions:[MotionEntity]    = [MotionEntity](count: Settings.bufferLength, repeatedValue: MotionEntity(0, 0, 0))

    var threshold:Double = 0
    
    var negaeriNow = false
    
    /// 計測
    ///
    /// レム／ノンレムを切り替えるとき true を返す
    func addMotion(x: Double, _ y: Double, _ z: Double) -> Bool {
        
        self.allMotionLength += 1
        
        self.motions[index] = MotionEntity(x, y, z)
        self.index = (self.index + 1) % Settings.bufferLength
        
        // フィルタによる値を取得
        let filteredMotion = self.smoothByFilter()
        
        // しきい値を計算するための準備期間だったら
        if self.allMotionLength < Settings.preparingDataLength {
            decideThreshold(filteredMotion)
        } else {
            print("\(self.threshold) < \(filteredMotion.z) negaeri: \(negaeriNow)")
            if (!negaeriNow && self.threshold < filteredMotion.z) {
                // レム／ノンレムを切り替える
                negaeriNow = true
                print("------CHANGE-----")
                return true
            } else if(self.threshold > filteredMotion.z) {
                negaeriNow = false
            }
        }
        return false
    }
    
    /// しきい値の決定
    ///
    /// 最初のN個のデータのMeanフィルタによる値の最大値 × M
    func decideThreshold(m: MotionEntity) {
        // いったんZ軸の値のみを計算する
        let z = m.z * Settings.timesToDecideThreshold
        if z > self.threshold {
            print("UPDATE threshold: \(z)")
            self.threshold = z
        }
    }
    
    // Parseに保存
    func saveToParse(userName: String, musicStatus: Bool) {
        
        //Parse: create a table of acceletometer data
        let object = PFObject(className:userName)
        
        if let user  = PFUser.currentUser(),
            objectID = user.objectId { object["userID"] = objectID }
        
        // フィルタによる値を取得
        let filteredMotion = self.smoothByFilter()
        
        //Parse: setting up variables details
        object["DifferenceX"] = filteredMotion.x
        object["DifferenceY"] = filteredMotion.y
        object["DifferenceZ"] = filteredMotion.z
        
        //Parse: send! checking if it's sucessful
        object.saveInBackgroundWithBlock{(success,error)->Void in
            if success == true{
//                print("Save to Parse: Successful")
            }else{
                print("Failed")
                print(error)
            }
        }
    }
    
    // フィルタによるスムージング
    func smoothByFilter() -> MotionEntity {
        if Settings.filterPattern == .Mean {
            return self.smoothByMeanFilter()
        } else {
            return self.smoothByMedianFilter()
        }
    }
    
    // Meanフィルタによるスムージング
    func smoothByMeanFilter() -> MotionEntity {
        var sumMotion = MotionEntity(0, 0, 0)
        for motion in self.motions {
            sumMotion += motion
        }
        return sumMotion / Settings.bufferLength
    }
    
    // Medianフィルタによるスムージング
    func smoothByMedianFilter() -> MotionEntity{
        return MotionEntity(
            motions.map({ (m) -> Double in
                return m.x
            }).sort{$0 < $1}[Settings.bufferIndexOfMiddle],
            motions.map({ (m) -> Double in
                return m.y
            }).sort{$0 < $1}[Settings.bufferIndexOfMiddle],
            motions.map({ (m) -> Double in
                return m.z
            }).sort{$0 < $1}[Settings.bufferIndexOfMiddle]
        )
    }
    
}
