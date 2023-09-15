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
    @State private var viewChange = true
    @State private var selection = 0
    @State private var selectedDate = Date()
    @State private var scrollOffset:CGFloat = 0
    @Namespace var testName
    
    var body: some View {
        VStack(spacing:0) {
            Text("")
            customToolbar
            if viewChange {
                testScrollView
            }else {
                testNormalView
            }
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
                        ForEach(-36...0,id:\.self) { num in
                            listCell(num: num)
                        }
                    }.padding(.horizontal,20)
                        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                        .onChange(of: selection) { newValue in
                            withAnimation {
                                proxy.scrollTo(newValue,anchor: .center)
                            }
                        }
                }.scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            }
        }.padding(.vertical,20)
        //.background(Color.gray)
        
    }
    
    @ViewBuilder
    func listCell(num:Int) -> some View {
        if selectedDate.addMonth(n: num).string(format: "M") == "1" {
            VStack(spacing:3) {
                Text(selectedDate.addMonth(n: num).string(format: "yyyy"))
                HStack {
                    Rectangle()
                        .frame(width: 2,height: 27)
                        .foregroundColor(.gray)
                }
            }
        }
        Button {
            withAnimation {
                selection = num
                viewChange.toggle()
            }
        } label: {
            VStack(spacing:10) {
                //                                    Text("툴바 테스트\(num)")
                Text(selectedDate.addMonth(n: num).string(format: "M월"))
                    .foregroundColor(selection == num ? .green : .gray)
                if selection == num {
                    Rectangle()
                        .frame(maxWidth: .infinity,maxHeight: 2)
                    //.matchedGeometryEffect(id: "test1", in: testName)
                        .foregroundColor(Color.green)
                }else {
                    Rectangle()
                        .frame(maxWidth: .infinity,maxHeight: 2)
                        .foregroundColor(.clear)
                }
            }
        }.id(num)
    }
    
    var testScrollView: some View {
        ScrollView {
            ZStack {
                VStack {
                    ForEach(0...30, id: \.self) { index in
                        Button {
                            print(index)
                        } label: {
                            Text("Row \(index)")
                                .frame(maxWidth:.infinity,minHeight: 100)
                        }
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
    
    var testNormalView: some View {
        VStack {
            Text("test")
            Button {
                print("test")
            } label: {
                Text("testButton")
                    .frame(width: 100,height: 100)
                    .background(Color.green)
            }
            
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(Color.gray)
            .highPriorityGesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height < -70 {
                            withAnimation {
                                testBool = false
                            }
                        }
                        
                        if value.translation.height > 70 {
                            withAnimation {
                                testBool = true
                            }
                        }
                    })
    }
    
}

struct testKey:PreferenceKey {
    static var defaultValue: Value = 0
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
    
    typealias Value = CGFloat
}

//func dateString(num:Int) -> String {
//    let currentMonth = (Date().int(format: "M") + num) % 12
//    if currentMonth > 0 {
//        return "\(currentMonth)월"
//    }else {
//        return "\(currentMonth + 12)월"
//    }
//}
