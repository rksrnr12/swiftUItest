//
//  ContentView.swift
//  test0708
//
//  Created by iquest on 2022/07/08.
//

import SwiftUI
import Foundation
import LocalAuthentication


struct ContentView: View {
    
    @AppStorage("arrayData") var arrayData:Data?
    @AppStorage("myDayOff") var myDayOff = 2.5
    @StateObject private var gridViewModel = DropGridViewModel()
    @State private var isdayOff = false
    @State private var isHalfdayOff = false
    @State private var openSetting = false
    @State private var dayOffString = ""
    @State private var itemCount = 3
    @State private var openSheet = false
    @State private var sheetDetent:PresentationDetent = .height(100)
    @State private var isFaceID = false
    
    
    ///변동 그리드아이템 생성
    func gridColumns() -> [GridItem] {
        Array(repeating: .init(.flexible()), count: itemCount)
    }
    
    var body: some View {
        ScrollView{
            LazyVStack(pinnedViews:.sectionHeaders) {
                if isFaceID {
                    mainView()
                }else {
                    Button {
                        test()
                    } label: {
                        Text("로그인 다시시도")
                    }
                }
            }
        }
        .onAppear{
            if isFaceID == false {
                test()
            }
        }
        .sheet(isPresented: $openSheet, content: {
            HStack {
                Button {
                    withAnimation {
                        sheetDetent = .large
                    }
                } label: {
                    Text("크게")
                }
                
                Button {
                    withAnimation {
                        sheetDetent = .medium
                    }
                    
                } label: {
                    Text("작게")
                }
                
                Button {
                    withAnimation {
                        sheetDetent = .height(100)
                    }
                } label: {
                    Text("원래대로")
                }
                
                
            }
            //            .presentationDetents([sheetDetent,.medium,.large], selection: $sheetDetent)
            .presentationDetents([.height(100),.medium,.large])
            .presentationCornerRadius(10)
            .presentationBackgroundInteraction(.enabled(upThrough: .height(100)))
            .presentationBackground(.regularMaterial)
            
        })
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    //response:총 애니메이션 시간
                    //damping:튕기는 범위 작을수록 큼
                    //blendDuration: 튕기는 시간
                    //                    withAnimation(.spring(response: 0.7,dampingFraction: 0.725,blendDuration: 1.0)) {
                    //                        itemCount = .random(in: 2...10)
                    //                    }
                    openSheet.toggle()
                } label: {
                    Text("그리드변경")
                }
                
            }
            ToolbarItemGroup(placement:.bottomBar) {
                Spacer()
                toolBarBtn
            }
        }
        .task {
            if arrayData == nil {
                guard let data = try? JSONEncoder().encode(gridViewModel.gridItems) else { return }
                arrayData = data
            }else {
                guard let array = try? JSONDecoder().decode([Grid].self, from: arrayData!) else { return }
                gridViewModel.gridItems = array
            }
        }
    }
    
    func mainView() -> some View {
        Section(header: dayOffView) {
            LazyVGrid(columns: gridColumns()) {
                ForEach(gridViewModel.gridItems) { grid in
                    NavigationLink {
                        otherViews(title: grid.gridText)
                    } label: {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(maxWidth: .infinity,minHeight: 100)
                            .foregroundColor(Color(red: grid.number, green: grid.number2, blue: grid.number3))
                            .overlay {
                                Text(grid.gridText)
                                    .foregroundColor(.white)
                            }
                            .onDrag ({
                                gridViewModel.currentGrid = grid
                                return NSItemProvider(object: String(grid.gridText) as NSString)
                            })
                            .onDrop(of: [.text], delegate: DropViewDelegate(gird: grid, gridData: gridViewModel))
                    }.buttonStyle(.pushAnimation)
                    
                }
            }
        }
    }
    
    //MARK: -이동하는 뷰
    @ViewBuilder
    func otherViews(title:String) -> some View {
        switch title {
        case "바차트" :
            BarChart()
        case "달력" :
            calendar()
        case "탭뷰":
            tabVIew()
        case "플로팅버튼":
            floatingButton()
        case "제스쳐테스트":
            GestureTest()
        case "지도":
            MapTest()
        case "카드게임":
            cardGame()
        case "URL":
            URLTest()
        case "햅틱":
            HapticTest()
        case "애니메이션":
            AnimationTest()
        case "게이지테스트":
            GaugeTest()
        case "아일랜드" :
            islandTest { a, b in
                Button {
                    print(a)
                    print(b)
                } label: {
                    Text(String(a))
                }
            }
        default:
            Text("")
        }
    }
    
    //MARK: -연차 내용 뷰
    var dayOffView:some View {
        VStack(spacing:20){
            Text("내 연차 = \(String(format: "%.1f", myDayOff))일")
            HStack{
                basicBtn(title: "연차 사용") {
                    isdayOff.toggle()
                }
                basicBtn(title: "반차 사용") {
                    isHalfdayOff.toggle()
                }
            }.alert("반차사용??", isPresented: $isHalfdayOff) {
                HStack{
                    basicBtn(title: "아니요")
                    basicBtn(title: "네") {
                        myDayOff -= 0.5
                    }
                }
            }
            .alert("연차사용??", isPresented: $isdayOff) {
                HStack{
                    basicBtn(title: "아니요")
                    basicBtn(title: "네") {
                        myDayOff -= 1
                    }
                }
            }
        }.frame(maxWidth: .infinity)
            .padding(.vertical,15)
            .background(Material.bar)
            .cornerRadius(15)
    }
    
    
    //MARK: - 툴바 버튼
    var toolBarBtn: some View {
        basicBtn(title: "설정") {
            openSetting.toggle()
        }
        .alert("연차 수정", isPresented: $openSetting) {
            TextField("숫자만 입력", text: $dayOffString).keyboardType(.numbersAndPunctuation)
            HStack{
                basicBtn(title: "취소") {
                    dayOffString = ""
                }
                basicBtn(title: "수정") {
                    guard let num = Double(dayOffString)
                    else {
                        HapticManager.manager.notification(type: .error)
                        return
                    }
                    myDayOff = num
                    dayOffString = ""                }
            }
        } message: {
            Text("날짜를 입력하세요")
        }
    }
    
    //MARK: - 기본버튼
    @ViewBuilder
    func basicBtn(title:String, action:@escaping () -> Void = {}) -> some View {
        Button(title) {
            action()
        }
    }
    
    func test() {
        let context = LAContext()
        var error:NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "testApp"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    isFaceID = true
                }else {
                    isFaceID = false
                }
            }
        }else {
            print("터치아이디,페이스아이디 없음")
        }
    }
}


