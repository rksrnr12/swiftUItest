//
//  GestureTest.swift
//  test0708
//
//  Created by iquest on 2022/07/29.
//

import SwiftUI
import Algorithms

struct GestureTest: View {
    
    var body: some View {
        VStack{
            zoomTest {
                Text("상단")
            }
            zoomTest {
                Text("test")
            }
        }
    }

    
}

struct zoomTest<Content:View>:View {
    
    @State private var currentAmount:CGFloat = 0
    @State private var lastAmount:CGFloat = 1
    @State private var dragOffset = CGSize.zero
    @State private var bgColor = Color.green
    @ViewBuilder let test:Content
    
    var body: some View {
            test
                .foregroundColor(.white)
                .padding(50)
                .background(bgColor)
                .offset(dragOffset)
                .scaleEffect(currentAmount + lastAmount)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    currentAmount = value - 1
                                }
                                .onEnded { value in
                                    withAnimation(.spring(response: 0.6,dampingFraction: 0.6)) {
                                        currentAmount = 0
                                        dragOffset = .zero
                                    }
                                }
                        )
                        .highPriorityGesture(
                            DragGesture()
                            .onChanged { gesture in
                                dragOffset = gesture.translation
                                print(gesture.translation)
                                bgColor = dragOffset.width > 80 ? .blue : .green
                            }
                            .onEnded { gesture in
                                withAnimation(.spring(response: 0.7,dampingFraction: 0.6)) {
                                    dragOffset = .zero
                                    bgColor = dragOffset.width > 80 ? .blue : .green
                                }
                            })
//                .gesture(
//                    DragGesture()
//                        .onChanged { gesture in
//                            dragOffset = gesture.translation
//                            print(gesture.translation)
//                        }
//                        .onEnded { gesture in
//                            withAnimation(.spring(response: 0.7,dampingFraction: 0.6)) {
//                                dragOffset = .zero
//                            }
//                        }
//                )
                
    }
}




