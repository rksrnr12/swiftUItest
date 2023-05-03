//
//  ContentView.swift
//  WatchTest0708 Watch App
//
//  Created by khg on 2023/05/03.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    NavigationLink {
                        NewWatchView()
                            .navigationTitle("이동한 뷰")
                    } label: {
                        Text("이동하기")
                            .foregroundColor(.green)
                    }
                    Text("test")
                    
                    Image("dog")
                        .resizable()
                        .frame(width:200,height: 200)
                        .clipShape(Circle())
                }
            }.navigationTitle("처음화면")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}
