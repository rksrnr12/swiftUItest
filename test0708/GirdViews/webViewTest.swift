//
//  webViewTest.swift
//  test0708
//
//  Created by khg on 2/15/24.
//

import SwiftUI
import WebKit
import SafariServices


struct webViewTest: View {
    
    @State private var openSafari = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                Button("SFSafari") {
                    openSafari.toggle()
                }
            }
            testWKWebView(url: URL(string: "https://www.naver.com")!)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
            
        }
        .sheet(isPresented: $openSafari) {
            testSFSafariView(url: URL(string: "https://www.google.com")!)
        }
    }
}



struct testWKWebView: UIViewRepresentable {
    
    var url:URL

    func makeUIView(context: Context) -> some UIView {
        let view = WKWebView(frame: .zero)
        view.load(URLRequest(url: url))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject,WKNavigationDelegate {
        let parent: testWKWebView
        
        init(parent: testWKWebView) {
            self.parent = parent
        }
    }
    
}

struct testSFSafariView: UIViewControllerRepresentable {
    
    var url:URL

    func makeUIViewController(context: Context) -> some UIViewController {
        let view = SFSafariViewController(url: url)
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
}


//func backSwipeGesture(action: @escaping () -> ()) -> some View {
//    self
//        .gesture(
//            DragGesture()
//                .onChanged { value in
//                    if value.startLocation.x < 17 && value.location.x > 50  {
//                        action()
//                    }
//                }
//        )
//}

