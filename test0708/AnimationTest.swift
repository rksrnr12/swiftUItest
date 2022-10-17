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
        
        if isDetail {
            VStack{
                Image("dog")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .matchedGeometryEffect(id: "test", in: test)
                    .frame(maxWidth: .infinity,maxHeight: 400)
                    .onTapGesture {
                        withAnimation {
                            isDetail.toggle()
                        }
                    }.padding()
            }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(Color("basicColor"))
                .ignoresSafeArea()
                //.navigationBarBackButtonHidden(true)
        }else {
            VStack{
                
                Image("dog")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .matchedGeometryEffect(id: "test", in: test)
                    .frame(width: 150, height: 150)
                Spacer()
                
            }.onTapGesture {
                withAnimation {
                    isDetail.toggle()
                }
            }.padding()
        }
    }
}

struct AnimationTest_Previews: PreviewProvider {
    static var previews: some View {
        AnimationTest()
    }
}
