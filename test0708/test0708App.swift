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
    
//    @State private var test = false
//    @State private var player = AVPlayer(url: Bundle.main.url(forResource: "", withExtension: "")!)
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView()
                    .navigationBarTitleDisplayMode(.inline)
                    .onOpenURL { url in
                        print("url = \(url)")
                        print("uri.path = \(url.path)")
                        print("url.apos = \(url.absoluteString)")
                        if url.query != nil {
                            print("url.query = \(url.query()!)")
                            var test = URLComponents(string: url.absoluteString)?.queryItems ?? []
                            print(test)
                        }
                    }
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

        }
    }
}

struct Test123 {
    var test = ""
    var asd = ""
}
