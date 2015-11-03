//
//  MotionEntity.swift
//  ParseStarterProject
//
//  Created by 樋山理紗 on 2015/11/03.
//  Copyright © 2015年 Parse. All rights reserved.
//

import Foundation

// 加速度データ
struct MotionEntity {
    let x: Double
    let y: Double
    let z: Double
    
    init(_ x: Double, _ y: Double, _ z: Double){
        self.x = x > 0 ? x : -x
        self.y = y > 0 ? y : -y
        self.z = z > 0 ? z : -z
    }
}

func + (left: MotionEntity, right: MotionEntity) -> MotionEntity {
    return MotionEntity(
        left.x + right.x,
        left.y + right.y,
        left.z + right.z
    )
}

func += (inout left: MotionEntity, right: MotionEntity) {
    left = MotionEntity(
        left.x + right.x,
        left.y + right.y,
        left.z + right.z
    )
}

func / (left: MotionEntity, right: Int) -> MotionEntity {
    let division = Double(right)
    return MotionEntity(
        left.x / division,
        left.y / division,
        left.z / division
    )
}