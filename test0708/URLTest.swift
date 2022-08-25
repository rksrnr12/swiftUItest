//
//  URL.swift
//  test0708
//
//  Created by khg on 2022/08/22.
//

import SwiftUI
import Foundation

struct URLTest: View {
    
    @Environment(\.openURL) var openURL
    @State private var isPush = false
    
    var body: some View {
        VStack(spacing:10){
            Text("지도")
                .onTapGesture {
                    openURL(URL(string:"Maps:")!)
                }
            Text("문자")
                .onTapGesture {
                    openURL(URL(string: "sms:01027085060")!)
                }
            Text("카카오톡")
                .onTapGesture {
                    openURL(URL(string: "kakaotalk://")!) { accepted in
                        if !accepted {
                            openURL(URL(string: "http://apps.apple.com/kr/app/id362057947")!)
                        }
                    }
                    
                    
                    //openURL(URL(string: "http://apps.apple.com/kr/app/id362057947")!)
                
                }
            Text("네이버")
                .onTapGesture {
                    openURL(URL(string: "naversearchapp:")!)
                }
            Link(destination: URL(string: "tel:01027085060")!) {
                Text("전화")
            }
            Text("yonghk1233@naver.com")
                .tint(.green)
            Link(destination: URL(string: "testApp://?testtesttest")!) {
                Text("앱 전환")
            }
            NavigationLink(isActive: $isPush) {
                Text("이동")
            } label: {
                Text("카드게임")
            }
        }.onOpenURL { url in
            print("페이지 이동 실행")
        }
    }
}

struct URL_Previews: PreviewProvider {
    static var previews: some View {
        URLTest()
    }
}
