//
//  testView.swift
//  test0708
//
//  Created by khg on 2022/12/13.
//

import SwiftUI

struct testView<content>: View where content:View  {
    
    var testView:content
    
    init(@ViewBuilder test: () -> content ) {
        testView = test()
    }
    
    var body: some View {
        testView
    }
    
}

