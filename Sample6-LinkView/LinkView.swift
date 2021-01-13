//
//  LinkView.swift
//  Sample6-LinkView
//
//  Created by keiji yamaki on 2021/01/11.
//

import SwiftUI


struct LinkView: View {
    @State var mySpot = MySpot()
    @State var viewSize = ViewSize()
    @State var largeMove : CGSize = .zero
    @State var smallMove : CGSize = .zero
    @State var zoomMove : CGSize = .zero
    @GestureState var magnifyBy = CGFloat(1.0)  // ピンチの倍率データ
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                // 拡大画面（大画面）
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width:viewSize.largeView.width, height: viewSize.largeView.height)
                    .overlay(
                        MyView(mySpot: mySpot, viewSize: viewSize.largeView, spotSize: viewSize.largeSpot)
                            .offset(x:viewSize.largeSpot.minX, y:viewSize.largeSpot.minY)
                            .foregroundColor(.red)
                            .frame(width:viewSize.largeSpot.width * magnifyBy, height: viewSize.largeSpot.height * magnifyBy)
                            .gesture(largeDrag)     // ドラッグ処理
                            .gesture(largeZoom)     // 拡大処理
                        , alignment: .topLeading)
                // 全体画面（小画面）
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width:viewSize.smallView.width, height: viewSize.smallView.height)
                    .overlay(
                        ZStack {
                            MyView(mySpot: mySpot, viewSize: viewSize.smallView, spotSize: viewSize.smallSpot)
                                .offset(x:viewSize.smallSpot.minX, y:viewSize.smallSpot.minY)
                                .foregroundColor(.blue)
                                .frame(width: viewSize.smallSpot.width, height: viewSize.smallSpot.height)
                            // ZOOMエリア
                            Rectangle()
                                .opacity(0.01)
                                .frame(width:viewSize.zoomArea.width, height:viewSize.zoomArea.height)
                                .position(x:viewSize.zoomArea.midX, y: viewSize.zoomArea.midY)
                                .gesture(zoomDrag)     // ドラッグ処理
                            Rectangle()
                                .stroke(Color.red, lineWidth: 2)
                                .frame(width:viewSize.zoomArea.width, height:viewSize.zoomArea.height)
                                .position(x:viewSize.zoomArea.midX, y: viewSize.zoomArea.midY)
                        }
                        , alignment: .topLeading)
            }
            // 初期表示で、Viewのサイズを設定
            .onAppear{
                initialData(frameSize: geometry.size)
            }
        }
    }
    // ズームエリアのドラッグ処理
    var zoomDrag: some Gesture {
        
        DragGesture()
            .onChanged { value in
                // 画面以上に大きさになるように調整
                zoomMove = viewSize.moveSpot(type: .zoom, moveSize: value.translation)
            }
            .onEnded { value in
                viewSize.zoomAreaOrigin = CGPoint(x: viewSize.zoomAreaOrigin.x + zoomMove.width,
                                                   y: viewSize.zoomAreaOrigin.y + zoomMove.height)
                largeMove = .zero
            }
    }
    // 拡大画面のドラッグ処理
    var largeDrag: some Gesture {
        
        DragGesture()
            .onChanged { value in
                // 画面以上に大きさになるように調整
                largeMove = viewSize.moveSpot(type: .large, moveSize: value.translation)
            }
            .onEnded { value in
                viewSize.largeSpotOrigin = CGPoint(x: viewSize.largeSpotOrigin.x + largeMove.width,
                                                   y: viewSize.largeSpotOrigin.y + largeMove.height)
                largeMove = .zero
            }
    }
    // 拡大画面のピンチ処理
    var largeZoom: some Gesture {
        MagnificationGesture()
            // ピンチの確定
            .onEnded { value in
                viewSize.largeSpotSize = CGSize(width : viewSize.largeSpot.size.width * magnifyBy,
                                                height: viewSize.largeSpot.size.height * magnifyBy)
            }
            // ピンチの移動
            .updating($magnifyBy) { currentState, gestureState, transaction in
                gestureState = currentState
            }

    }
    // 画面のサイズとマイスポットより、大・小の画面とスポットの位置をサイズを決定
    private func initialData (frameSize: CGSize){
        let viewWidth = frameSize.width
        let smallViewHeightLimit = frameSize.height / 4
        let smallSpotWidth = frameSize.width
        let smallSpotHeight = smallSpotWidth * mySpot.size.height / mySpot.size.width
        let smallViewHeight =  smallSpotHeight < smallViewHeightLimit ? smallSpotHeight : smallViewHeightLimit
        let largeViewHeight = frameSize.height - smallViewHeight
        let largeSpotHeight = largeViewHeight
        let largeSpotWidth = largeSpotHeight * mySpot.size.width / mySpot.size.height
        let entranceX = largeSpotWidth * mySpot.entrancePosition.x / mySpot.size.width
        let largeXPosition : CGFloat
        if entranceX < viewWidth / 2 {
            largeXPosition = 0
        } else if entranceX > largeSpotWidth - viewWidth / 2 {
            largeXPosition = largeSpotWidth - viewWidth
        } else {
            largeXPosition = -entranceX + viewWidth / 2
        }
        let smallXPosition : CGFloat = (smallSpotWidth - viewWidth) / 2
        viewSize = ViewSize(
            largeView: CGSize(width: viewWidth, height: largeViewHeight),
            smallView: CGSize(width: viewWidth, height: smallViewHeight),
            largeSpot: CGRect(origin: CGPoint(x: largeXPosition, y:0), size: CGSize(width: largeSpotWidth, height: largeSpotHeight)),
            smallSpot: CGRect(origin: CGPoint(x:smallXPosition, y:0), size: CGSize(width:smallSpotWidth, height:smallSpotHeight)),
            smallViewHeightLimit: smallViewHeightLimit)
    }

}
/*
struct LinkView_Previews: PreviewProvider {
    @State var mySpot = MySpot(size: .zero, entrancePosition: .zero)
    static var previews: some View {
        LinkView(mySpot: $mySpot)
    }
}
*/
