//
//  test0708App.swift
//  test0708
//
//  Created by iquest on 2022/07/08.
//

import SwiftUI

@main
struct test0708App: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
                    .navigationBarTitleDisplayMode(.inline)
//                    .onOpenURL { url in
//                        print("url = \(url)")
//                        print("uri.path = \(url.path)")
//                        print("url.apos = \(url.absoluteString)")
//                        if url.query != nil {
//                            print("url.query = \(url.query!)")
//                        }
//                        if url.absoluteString == "test0708://URLtest" {
//                           print("여기 실행")
//                        }
//                    }
            }
        }
    }
}
