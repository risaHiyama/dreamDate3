//
//  Settings.swift
//  ParseStarterProject
//
//  Created by 樋山理紗 on 2015/11/03.
//  Copyright © 2015年 Parse. All rights reserved.
//

import Foundation

enum Status {
    case Rem
    case NonRem
}

enum FilterPatern {
    case Mean
    case Median
}

enum Settings {
    // フィルタパターン
    static let filterPattern:FilterPatern = .Mean
    
    // モーションバッファの長さ（過去何回分のデータを利用するか）
    static let bufferLength = 20
    
    // モーションバッファの中央のインデックス
    static let bufferIndexOfMiddle = bufferLength / 2
    
    // しきい値を計算する期間に該当する最初のデータ数
    static let preparingDataLength = 80
    
    //寝るまで待つ時間
    static let timeWaitingForUserToSleep = 60*30
    
    // しきい値を計算する際、乗算する定数
    static let timesToDecideThreshold = 1.8
}