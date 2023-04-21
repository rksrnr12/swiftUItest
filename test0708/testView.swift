//
//  testView.swift
//  test0708
//
//  Created by khg on 2022/12/13.
//

import SwiftUI

struct testView<content>: View where content:View  {
    
    //dismiss할 때 사용
    @Environment(\.dismiss) private var dismiss
    
    var testView:content
    var text = "aaa"
    /**
    주석 테스트)

        Text("test")
            .NotoSansReg(size:10)
     
    - parameter size:폰트 크기
     
    - Returns: test
    */
    init(@ViewBuilder test: (_ A:String,_ B:String) -> content = { A,B in Text("test") } ) {
        testView = test(text, "abc")
    }
    
    var body: some View {
        testView
    }
    
}

