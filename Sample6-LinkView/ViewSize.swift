//
//  ViewSize.swift
//  Sample6-LinkView
//
//  Created by keiji yamaki on 2021/01/12.
//

import SwiftUI

struct ViewSize {
    // 画面のサイズ
    private var storeLargeView : CGSize
    private var storeSmallView : CGSize
    // スポットのサイズ
    private var storeLargeSpot : CGRect
    private var storeSmallSpot : CGRect
    private var storeSmallViewHeightLimit : CGFloat
    private var storeZoomArea : CGRect
    
    var largeView : CGSize {
        get { return storeLargeView }
    }
    var smallView : CGSize {
        get { return storeSmallView }
    }
    var largeSpot : CGRect {
        get { return storeLargeSpot }
    }
    var smallSpot : CGRect {
        get { return storeSmallSpot }
    }
    // 拡大画面の起点
    var largeSpotOrigin : CGPoint {
        get { return storeLargeSpot.origin }
        set { storeLargeSpot.origin = newValue
            setZoomArea()
        }
    }
    // 拡大画面のサイズ
    var largeSpotSize : CGSize {
        get { return storeLargeSpot.size }
        set { storeLargeSpot.size = newValue
            setZoomArea()
        }
    }
    // ズームエリア
    var zoomArea : CGRect {
        get { return storeZoomArea}
        set { storeZoomArea = newValue
            let zoom = largeView.width / storeZoomArea.width
            storeLargeSpot.origin = CGPoint(x: -zoomArea.origin.x * zoom, y: -zoomArea.origin.y * zoom)
            storeLargeSpot.size.width = smallSpot.width * zoom
            storeLargeSpot.size.height = smallSpot.height * zoom
        }
    }
    // ズームエリアの起点
    var zoomAreaOrigin : CGPoint {
        get { return storeZoomArea.origin }
        set { storeZoomArea.origin = newValue
            setLargeSpot()
        }
    }
    // 初期化
    init(){
        self.storeLargeView = .zero
        self.storeSmallView = .zero
        self.storeLargeSpot = .zero
        self.storeSmallSpot = .zero
        self.storeSmallViewHeightLimit = .zero
        self.storeZoomArea = .zero
    }
    init( largeView: CGSize, smallView: CGSize, largeSpot: CGRect, smallSpot: CGRect, smallViewHeightLimit: CGFloat){
        self.storeLargeView = largeView
        self.storeSmallView = smallView
        self.storeLargeSpot = largeSpot
        self.storeSmallSpot = smallSpot
        self.storeSmallViewHeightLimit = smallViewHeightLimit
        let zoom = storeSmallSpot.width / storeLargeSpot.width
        self.storeZoomArea = CGRect (origin: CGPoint(x: -storeLargeSpot.minX * zoom, y: -storeLargeSpot.minY * zoom),
                                     size: CGSize(width:storeLargeView.width * zoom, height: storeLargeView.height * zoom))
    }
    // Zoomエリアの設定：拡大画面の位置から
    mutating func setZoomArea(){
        let zoom = storeSmallSpot.width / storeLargeSpot.width
        self.storeZoomArea.origin = CGPoint(x: -storeLargeSpot.minX * zoom, y: -storeLargeSpot.minY * zoom)
        self.storeZoomArea.size = CGSize(width:storeLargeView.width * zoom, height: storeLargeView.height * zoom)
    }
    // 拡大画面の設定：Zoomエリアの位置から
    mutating func setLargeSpot(){
        let zoom = storeLargeView.width / storeZoomArea.width
        self.storeLargeSpot.origin = CGPoint(x: -storeZoomArea.minX * zoom, y: -storeZoomArea.minY * zoom)
        self.storeLargeSpot.size = CGSize(width:storeSmallSpot.width * zoom, height: storeSmallSpot.height * zoom)
    }
    // スポットの移動
    mutating func moveSpot (type: ViewType, moveSize: CGSize)->CGSize {
        var moveSize : CGSize = moveSize
        
        // 拡大画面の移動
        switch type {
        case .large:
            // 移動後の頂点を設定
            let p1 = CGPoint(x: storeLargeSpot.minX+moveSize.width, y: storeLargeSpot.minY+moveSize.height)
            let p2 = CGPoint(x: storeLargeSpot.maxX+moveSize.width, y: storeLargeSpot.minY+moveSize.height)
            let p3 = CGPoint(x: storeLargeSpot.minX+moveSize.width, y: storeLargeSpot.maxY+moveSize.height)
            //　画面の幅より大きい場合、スポットの頂点が画面の中に入らないようにする
            if storeLargeSpot.size.width > storeLargeView.width {
                if p1.x > 0 {   // P1が0より大きい時は、０になるように設定
                    moveSize.width = -storeLargeSpot.minX
                }
                if p2.x < storeLargeView.width {    // P2が画面サイズより小さい場合は、画面サイズになるように設定
                    moveSize.width = storeLargeView.width - storeLargeSpot.maxX
                }
            }else{  // 画面の幅より小さい場合、スポットの頂点が画面の外に入らないようにする
                if p1.x < 0 {   // P1が0より小さい時は、０になるように設定
                    moveSize.width = -storeLargeSpot.minX
                }
                if p2.x > storeLargeView.width {    // P2が画面サイズより大きい場合は、画面サイズになるように設定
                    moveSize.width = storeLargeView.width - storeLargeSpot.maxX
                }
            }
            // スポットの高さは、画面の高さより大きくする
            if p1.y > 0 {   // P1が0より大きい時は、０になるように設定
                moveSize.height = -storeLargeSpot.minY
            }
            if p3.y < storeLargeView.height {   // P3が画面サイズより小さい場合は、画面サイズになるように設定
                moveSize.height = storeLargeView.height - storeLargeSpot.maxY
            }
            // Zoomエリアを設定
            setZoomArea()
        // 全体画面の移動
        case .small:
            break
        // ズームエリアの移動
        case .zoom:
            break
            
        }
        
        return moveSize
        
    }
    
    

}


enum ViewType {
    case large  // 拡大画面：大
    case small  // 全体画面：小
    case zoom   // ズームエリア：全体画面で拡大画面のエリア表示
}
