//
//  MySpot.swift
//  Sample6-LinkView
//
//  Created by keiji yamaki on 2021/01/11.
//

import SwiftUI

struct MySpot {
    var size : CGRect               // マイスポットのサイズ
    var entrancePosition : CGPoint  // 入り口の位置
    var areas : [CGRect] = []       // マイスポットの配置されるエリア
    // 初期化
    init(size:CGRect, entrancePosition: CGPoint){
        self.size = size
        self.entrancePosition = entrancePosition
    }
    init(){
        size = CGRect(origin: .zero, size: CGSize(width:500, height:100))
        areas = [CGRect(origin:CGPoint(x:10,y:10), size: CGSize(width:20, height: 5)),
                 CGRect(origin:CGPoint(x:40,y:10), size: CGSize(width:20, height: 5)),
                 CGRect(origin:CGPoint(x:70,y:10), size: CGSize(width:20, height: 5)),
                 CGRect(origin:CGPoint(x:10,y:20), size: CGSize(width:20, height: 5)),
                 CGRect(origin:CGPoint(x:40,y:20), size: CGSize(width:20, height: 5)),
                 CGRect(origin:CGPoint(x:70,y:20), size: CGSize(width:20, height: 5))
                ]
        entrancePosition = CGPoint(x:20, y: 18)
    }
}
