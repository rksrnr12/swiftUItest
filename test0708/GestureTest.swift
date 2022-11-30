//
//  GestureTest.swift
//  test0708
//
//  Created by iquest on 2022/07/29.
//

import SwiftUI
import Algorithms

struct GestureTest: View {
    
    @State private var test = [10,20,30,40,50,60,70,80,90,100]
    @State private var currentAmount:CGFloat = 0
    @State private var lastAmount:CGFloat = 1
    
    var body: some View {
        zoomTest {
            Text("test")
        }
    }

    
}

struct zoomTest<Content:View>:View {
    
    @State private var currentAmount:CGFloat = 0
    @State private var lastAmount:CGFloat = 1
    @State private var dragOffset = CGSize.zero
    @ViewBuilder let test:Content
    
    var body: some View {
            test
                .foregroundColor(.white)
                .padding(50)
                .background(Color.green)
                .offset(dragOffset)
                .scaleEffect(currentAmount + lastAmount)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    currentAmount = value - 1
                                }
                                .onEnded { value in
                                    withAnimation(.spring()) {
                                        currentAmount = 0
                                    }
                                }
                        )
//                .gesture(
//                    DragGesture()
//                        .onChanged { gesture in
//                            dragOffset = gesture.translation
//                            print(gesture.translation)
//                        }
//                        .onEnded { gesture in
//                            dragOffset = .zero
//                        }
//                )
    }
}




