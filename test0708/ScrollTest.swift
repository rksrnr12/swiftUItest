//
//  ScrollTest.swift
//  test0708
//
//  Created by khg on 2022/09/08.
//

import SwiftUI

struct ScrollTest: View {
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews:.sectionHeaders) {
                Section(header: header) {
                    ForEach(1..<5) { data in
                        Text(String(data))
                    }.frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    var header: some View {
        Text("header")
            .foregroundColor(.white)
            .background(Color.white)
    }
}
