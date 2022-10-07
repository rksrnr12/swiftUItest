//
//  ContentView.swift
//  test0708
//
//  Created by iquest on 2022/07/08.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @Environment(\.presentationMode) var presentMode
    @AppStorage("myDayOff") var myDayOff = 2.5
    @State private var dayOffString = ""
    @State private var isShowingSheet = false
    @State private var isPush = false
    @State private var test = ""
    @State private var isdayOff = false
    @State private var isHalfdayOff = false
    @State private var isOpen = false
    
    
    var body: some View {
        
        ScrollView{
            VStack(spacing:20){
                Group{
                    Button("Show sheet", action: {
                        isShowingSheet.toggle()
                    })
                    .sheet(isPresented: $isShowingSheet, content: {
                        ViewOne(showParentSheet: $isShowingSheet)
                    })
                    NavigationLink("barChart") {
                        BarChart()
                    }
                    NavigationLink("calendar") {
                        calendar()
                    }
                    NavigationLink("tabView") {
                        tabVIew()
                    }
                    NavigationLink("floationgButton") {
                        floatingButton()
                    }
                    NavigationLink("datePicker") {
                        datePicker()
                    }
                    NavigationLink("MapTest") {
                        MapTest()
                    }
                    NavigationLink("cardGame") {
                        cardGame()
                    }
//                    NavigationLink(value: $isPush) {
//                        Text("url 오픈")
//                    }
                    NavigationLink(isActive: $isPush) {
                        URLTest()
                    } label: {
                        Text("url 오픈")
                    }
                }
                NavigationLink("HapticTest") {
                    HapticTest()
                }
                NavigationLink("AnimationTest") {
                    AnimationTest()
                }
                NavigationLink("GestureTest") {
                    GestureTest()
                }
                NavigationLink("islandTest") {
                    islandTest()
                }
                Text("내 연차 = \(String(format: "%.1f", myDayOff))일")
                HStack{
                    
                    Button {
                        isdayOff.toggle()
                    } label: {
                        Text("연차 사용")
                    }
                    
                    Button {
                        isHalfdayOff.toggle()
                    } label: {
                        Text("반차 사용")
                    }
                }.alert("반차사용??", isPresented: $isHalfdayOff) {
                    HStack{
                        Button("아니요") {
                            print("안함")
                        }
                        Button("네") {
                            myDayOff -= 0.5
                        }
                    }
                }
                .alert("연차사용??", isPresented: $isdayOff) {
                    HStack{
                        Button("아니요") {
                            print("안함")
                        }
                        Button("네") {
                            myDayOff -= 1
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem() {
                Button {
                    isOpen.toggle()
                } label: {
                    Text("설정")
                }
                .alert("연차 수정", isPresented: $isOpen) {
                    TextField("숫자만 입력", text: $dayOffString).keyboardType(.numbersAndPunctuation)
                    HStack{
                        Button("취소") {
                            dayOffString = ""
                        }
                        Button("수정") {
                            guard let num = Double(dayOffString)
                            else {
                                HapticManager.manager.notification(type: .error)
                                return
                            }
                            myDayOff = num
                            dayOffString = ""
                        }
                    }
                } message: {
                    Text("날짜를 입력하세요")
                }
            }
        }
        .onOpenURL { url in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isPush = true
            }
        }
    }
}

struct ViewOne: View {
    @Binding var showParentSheet : Bool
    
    var body: some View {
        NavigationView {
            NavigationLink("Go to ViewTwo", destination: ViewTwo(showParentSheet: $showParentSheet))
            //.isDetailLink(false)
        }
    }
}

struct ViewTwo: View {
    @Binding var showParentSheet : Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button("Dismiss sheet here") {
            showParentSheet = false
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
