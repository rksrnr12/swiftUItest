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
    
    @GestureState private var magnifyBy = 1.0
    @State private var currentAmount:CGFloat = 1
    @State private var testAmount:CGFloat = 1
    @State private var dragOffset = CGSize.zero
    @State private var bgColor = Color.green
    @ViewBuilder let test:Content
    
    var body: some View {
        test
            .foregroundColor(.white)
            .padding(50)
            .background(bgColor)
            .offset(dragOffset)
//            .scaleEffect(magnifyBy)
            .scaleEffect(currentAmount)// + lastAmount)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        currentAmount = (value * testAmount)
                        if currentAmount > 5 {
                            currentAmount = 5
                        }
                    }
                    .onEnded { value in
                        testAmount = currentAmount
                    }
//                MagnifyGesture()
//                    .updating($magnifyBy) { value, state, trans in
//                        state = value.magnification
//                    }
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
                            currentAmount = 1
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




