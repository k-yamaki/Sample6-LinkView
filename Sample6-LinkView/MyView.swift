//
//  MyView.swift
//  Sample6-LinkView
//
//  Created by keiji yamaki on 2021/01/11.
//

import SwiftUI

struct MyView : View {
    var mySpot : MySpot
    @Binding var viewSize : CGSize
    @Binding var spotSize : CGRect
    
    var body: some View {
        let magnify = spotSize.width / mySpot.size.width
        ZStack {
            Rectangle()
                .frame(width: spotSize.width, height: spotSize.height)
                // .position(x:spotSize.midX + move.width, y:spotSize.midY + move.height)
            ForEach(mySpot.areas.indices, id: \.self) { index in
                let area = mySpot.areas[index]
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: area.width * magnify, height: area.height * magnify)
                    .position(x: area.midX * magnify, y: area.midY * magnify)
            }
        }
    }
}
/*
struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
*/
