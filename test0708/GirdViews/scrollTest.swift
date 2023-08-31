//
//  scrollTest.swift
//  test0708
//
//  Created by khg on 2023/08/31.
//

import SwiftUI

struct scrollTest: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var testBool = true
    @State private var selection = 0
    @State private var scrollOffset:CGFloat = 0
    @Namespace var testName
    
    var body: some View {
        VStack(spacing:0) {
            Text("")
            customToolbar
            testScrollView
        }.toolbar(.hidden, for: .navigationBar)
    }
    
    var customToolbar: some View {
        VStack(spacing: 20) {
            if testBool {
                HStack {
                    Text("툴바 테스트")
                        .font(.headline)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onTapGesture {
                            dismiss()
                        }
                    Spacer()
                }.padding(.horizontal,20)
            }
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing:30) {
                        ForEach(0...30,id:\.self) { num in
                            Button {
                                withAnimation {
                                    selection = num
                                    //proxy.scrollTo(num,anchor: .center)
                                }
                            } label: {
                                VStack(spacing:10) {
                                    Text("툴바 테스트\(num)")
                                        .foregroundColor(selection == num ? .green : .black)
                                    if selection == num {
                                        Rectangle()
                                            .frame(maxWidth: .infinity,maxHeight: 2)
                                            .matchedGeometryEffect(id: "test1", in: testName)
                                            .foregroundColor(selection == num ? Color.green : Color.gray)
                                    }else {
                                        Rectangle()
                                            .frame(maxWidth: .infinity,maxHeight: 2)
                                            .foregroundColor(.clear)
                                    }
                                }
                            }.id(num)
                        }
                    }.padding(.horizontal,20)
                }
            }
        }.padding(.vertical,20)
            .background(Color.gray)
        
    }
    
    var testScrollView: some View {
        ScrollView {
            ZStack {
                VStack {
                    ForEach(0...30, id: \.self) { index in
                        Text("Row \(index)")
                            .frame(maxWidth:.infinity,minHeight: 100)
                    }
                    
                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .named("scroll")).minY
                        Color.clear.preference(key: testKey.self, value: offset)
                            .onAppear {
                                scrollOffset = offset
                                print(scrollOffset)
                            }
                    }
                }
            }
        }.coordinateSpace(name: "scroll")
            .onPreferenceChange(testKey.self) { value in
                print(scrollOffset)
                if testBool && value < scrollOffset - 20{
                    withAnimation {
                        testBool = false
                        print("꺼짐")
                    }
                }
                if !testBool && value > scrollOffset + 10 {
                    withAnimation {
                        testBool = true
                        print("켜짐")
                    }
                }
            }
    }
    
}

struct testKey:PreferenceKey {
    static var defaultValue: Value = 0
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
    
    typealias Value = CGFloat
}

