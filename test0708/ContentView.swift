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
    @State private var isShowingSheet = false
    @State private var isPush = false
    @State private var test = ""
    @State private var isdayOff = false
    @State private var isHalfdayOff = false
    @State private var isAddDay = false
    
    
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
                    //                NavigationLink("cardFlip") {
                    //                    cardFlip(cardColor: .constant(.blue),isShuffle:.constant(false),selectedColor: .constant(.white),)
                    //                }
                    NavigationLink("cardGame") {
                        cardGame()
                    }
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
                            isHalfdayOff = false
                        }
                        Button("네") {
                            myDayOff -= 0.5
                        }
                    }
                }
                .alert("연차사용??", isPresented: $isdayOff) {
                    HStack{
                        Button("아니요") {
                            isdayOff = false
                        }
                        Button("네") {
                            myDayOff -= 1
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement:.bottomBar) {
                HStack{
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        Text("설정")
                    }
                    Spacer()
                }
            }
            ToolbarItem {
                Text("test")
            }
        }
        .onOpenURL { url in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isPush = true
            }
        }
//        .onAppear{
//            myDayOff = 2.5
//            let format = DateFormatter()
//            format.dateFormat = "dd"
//            if format.string(from: Date()) == "17" {
//                myDayOff += 1
//            }
//        }
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
