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
    
    var body: some View {
        VStack(spacing:10){
            Text("지도")
                .onTapGesture {
                    openURL(URL(string:"Maps:")!)
                }
            Text("문자")
                .onTapGesture {
                    openURL(URL(string: "sms:yonghk1233@naver.com")!)
                }
            Text("카카오톡")
                .onTapGesture {
                    openURL(URL(string: "kakaotalk:")!)
                }
            Text("네이버")
                .onTapGesture {
                    openURL(URL(string: "naversearchapp::")!)
                }
        }
    }
}

struct URL_Previews: PreviewProvider {
    static var previews: some View {
        URLTest()
    }
}
