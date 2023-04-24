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
            if isDetail {
                Button {
                    withAnimation(.spring(response: 0.7,dampingFraction: 0.7,blendDuration: 1.0)) {
                        isDetail.toggle()
                    }
                } label: {
                    Image("dog")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .matchedGeometryEffect(id: "test", in: test)
                        .frame(width: 300)//isDetail ? 350 : 150)
                        .padding()
                        
                }.buttonStyle(PushButtonStyle(isBool: isDetail))
                Spacer()

            }else {
                imageBtn
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
                .matchedGeometryEffect(id: "test", in: test)
                .frame(width: 150)//isDetail ? 350 : 150)
                .padding()
                
        }.buttonStyle(PushButtonStyle(isBool: isDetail))

        
    }
    
    
    
}
