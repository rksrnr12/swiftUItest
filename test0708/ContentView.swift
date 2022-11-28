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
    @State private var isdayOff = false
    @State private var isHalfdayOff = false
    @State private var isOpen = false
    @State private var dayOffString = ""
    @State private var ColorArray:[Color] = Array(repeating: .white, count: 20)
    @State private var test = 3
        
    var name = ["바차트","달력","탭뷰","플로팅버튼","알고리즘","지도","카드게임","URL","햅틱","애니메이션","아일랜드"]
    
    func insert() {
        ColorArray.removeAll()
        while ColorArray.count != name.count {
            ColorArray.append(Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)).opacity(0.8))
        }
    }
    
    func gridColumns() -> [GridItem] {
        Array(repeating: .init(.flexible()), count: test)
    }
    
    var body: some View {
        ScrollView{
            LazyVStack(pinnedViews:.sectionHeaders) {
                Section(header: dayOffView) {
                    LazyVGrid(columns: gridColumns()) {
                        ForEach(Array(name.enumerated()),id: \.offset) { index,name in
                            NavigationLink {
                                otherViews(index: index)
                            } label: {
                                Text(name)
                                    .frame(maxWidth: .infinity,minHeight: 100)
                                    .foregroundColor(.black)
                                    .background(ColorArray[index])
//                                    .background(Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)).opacity(0.8))
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        test = .random(in: 2...10)
                        insert()
                    }
                } label: {
                    Text("그리드변경")
                }

            }
            ToolbarItemGroup(placement:.bottomBar) {
                Spacer()
                toolBarBtn
            }
        }
        .onAppear{
            insert()
        }
    }
    
    
    @ViewBuilder
    func otherViews(index:Int) -> some View {
        switch index {
        case 0 :
            BarChart()
        case 1 :
            calendar()
        case 2:
            tabVIew()
        case 3:
            floatingButton()
        case 4:
            GestureTest()
        case 5:
            MapTest()
        case 6:
            cardGame()
        case 7:
            URLTest()
        case 8:
            HapticTest()
        case 9:
            AnimationTest()
        case 10:
            islandTest()
        default:
            Text("")
        }
    }
    
    
    var dayOffView:some View {
        VStack(spacing:20){
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
        }.frame(maxWidth: .infinity)
            .padding(.vertical,15)
            .background(Material.bar)
            .cornerRadius(15)
    }
    
    var toolBarBtn: some View {
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


