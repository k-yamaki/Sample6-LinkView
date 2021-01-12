//
//  LinkView.swift
//  Sample6-LinkView
//
//  Created by keiji yamaki on 2021/01/11.
//

import SwiftUI

struct ViewSize {
    // 画面のサイズ
    var largeView : CGSize = .zero
    var smallView : CGSize = .zero
    // スポットのサイズ
    var largeSpot : CGRect = .zero
    var smallSpot : CGRect = .zero
    var smallViewHeightLimit : CGFloat = .zero
}


enum ViewType {
    case large
    case small
}
struct LinkView: View {
    @State var mySpot = MySpot()
    @State var viewSize = ViewSize()
    @State var largeMove : CGSize = .zero
    @State var smallMove : CGSize = .zero
    @GestureState var magnifyBy = CGFloat(1.0)

    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width:viewSize.largeView.width, height: viewSize.largeView.height)
                    .overlay(
                        MyView(mySpot: mySpot, viewSize: $viewSize.largeView, spotSize: $viewSize.largeSpot)
                            // .offset(x:1000, y:0)
                            .offset(x:viewSize.largeSpot.minX, y:viewSize.largeSpot.minY)
                            .foregroundColor(.red)
                            .frame(width:viewSize.largeSpot.width * magnifyBy, height: viewSize.largeSpot.height * magnifyBy)
                            .gesture(drag)              // ドラッグ処理
                            .gesture(magnification)     // 拡大処理
                        )
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width:viewSize.smallView.width, height: viewSize.smallView.height)
                    .overlay(
                        MyView(mySpot: mySpot, viewSize: $viewSize.smallView, spotSize: $viewSize.smallSpot)
                            .offset(x:viewSize.smallSpot.minX, y:viewSize.smallSpot.minY)
                            .foregroundColor(.blue)
                            .frame(width: viewSize.smallSpot.width, height: viewSize.smallSpot.height)
                )
            }
            // 初期表示で、Viewのサイズを設定
            .onAppear{
                initialData(frameSize: geometry.size)
            }
        }
    }
    // ドラッグの処理
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                largeMove.width = value.translation.width
                largeMove.height = value.translation.height
                let p1 = CGPoint(x: viewSize.largeSpot.minX+largeMove.width, y: viewSize.largeSpot.minY+largeMove.height)
                let p2 = CGPoint(x: viewSize.largeSpot.maxX+largeMove.width, y: viewSize.largeSpot.minY+largeMove.height)
                let p3 = CGPoint(x: viewSize.largeSpot.minX+largeMove.width, y: viewSize.largeSpot.maxY+largeMove.height)
                // let p4 = CGPoint(x: viewSize.largeSpot.maxX+largeMove.width, y: viewSize.largeSpot.maxY+largeMove.height)
                print("p1 = \(p1)")
                print("p2 = \(p2)")
                /*
                if (viewSize.largeSpot.size.width + largeMove.width) > viewSize.largeView.width {
                    if p1.x > 0 {
                        largeMove.width = -viewSize.largeSpot.minX
                    }
                    if p2.x < viewSize.largeView.width {
                        largeMove.width = viewSize.largeView.width - viewSize.largeSpot.maxX
                    }
                }
 */

                if p1.y > 0 {
                    largeMove.height = -viewSize.largeSpot.minY
                }
                if p3.y < viewSize.largeView.height {
                    largeMove.height = viewSize.largeView.height - viewSize.largeSpot.maxY
                }
            }
            .onEnded { value in
                viewSize.largeSpot.origin.x += largeMove.width
                viewSize.largeSpot.origin.y += largeMove.height
                largeMove = .zero
            }
    }
    // ピンチイン・ピンチアウトの処理
    var magnification: some Gesture {
        MagnificationGesture()
            // ピンチの確定
            .onEnded { value in
                viewSize.largeSpot.size.width *= magnifyBy
                viewSize.largeSpot.size.height *= magnifyBy
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
