//
//  test0708App.swift
//  test0708
//
//  Created by iquest on 2022/07/08.
//

import SwiftUI
import AVKit


@main
struct test0708App: App {
    @UIApplicationDelegateAdaptor var appDelegate:MyAppDelegate
    
    //@State private var test = false
    //@State private var player = AVPlayer(url: Bundle.main.url(forResource: "", withExtension: "")!)
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
                    .navigationBarTitleDisplayMode(.inline)
                    .onOpenURL { url in
                        print("url = \(url)")
                        print("uri.path = \(url.path)")
                        print("url.apos = \(url.absoluteString)")
                        if url.query != nil {
                            print("url.query = \(url.query!)")
                        }
                        if url.absoluteString == "test0708://URLtest" {
                            print("여기 실행")
                        }
                    }
                Text("메뉴를 선택하세요")
            }
//            .onAppear{
//                test = true
//            }
//            .fullScreenCover(isPresented: $test) {
//                ZStack {
//                    VideoPlayer(player: player)
//                        .disabled(true)
//                }.ignoresSafeArea()
//                    .onAppear {
//                        player.play()
//                    }
//                    .onDisappear{
//                        player.pause()
//                    }
//            }
//            NavigationSplitView {
//                ContentView()
//            } detail: {
//                Text("test")
//            }

        }
    }
    
    
    
}
