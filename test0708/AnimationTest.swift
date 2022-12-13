//
//  AnimationTest.swift
//  test0708
//
//  Created by khg on 2022/09/07.
//

import SwiftUI

struct AnimationTest: View {
    
    @Namespace var test
    @State private var isDetail = false
    
    var body: some View {
        VStack(alignment:.center){
            imageBtn
            testView {
                Text("사진을 클릭하세요")
                    .foregroundColor(.green)
            }
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(isDetail ? Color.gray : Color.black)
    }
    
    var imageBtn:some View {
        
        Button {
            withAnimation(.spring(response: 0.7,dampingFraction: 0.7,blendDuration: 1.0)) {
                isDetail.toggle()
            }
        } label: {
            Image("dog")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .frame(width: isDetail ? 350 : 150)
                .padding()
        }.buttonStyle(PushButtonStyle(isBool: isDetail))

        
    }
    
    
    
}
