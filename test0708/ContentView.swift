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
    @State private var dayOffString = ""
    @State private var openAlert = false
    @State private var isFaceID = false
    @State private var alertContent:AlertText = .init()
    var gridColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    
    var body: some View {
        VStack{
            if isFaceID {
                mainView()
            }else {
                Spacer()
                Button("로그인 다시시도") {
                    faceIDCHeck()
                }
                Spacer()
            }
        }.task {
            if isFaceID == false {
                faceIDCHeck()
            }
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
        ScrollView {
            LazyVStack(pinnedViews:.sectionHeaders) {
                Section(header: dayOffView) {
                    LazyVGrid(columns: gridColumns) {
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
                                        HapticManager.manager.notification(type: .success)
                                        gridViewModel.currentGrid = grid
                                        return NSItemProvider(object: String(grid.gridText) as NSString)
                                    })
                                    .onDrop(of: [.text], delegate: DropViewDelegate(gird: grid, gridData: gridViewModel))
                            }.buttonStyle(.pushAnimation)
                            
                        }
                    }.padding(.horizontal,5)
                }
            }
        }.toolbar {
            ToolbarItem {
                Button("숨기기") {
                    withAnimation {
                        isFaceID = false
                    }
                }
            }
        }
    }
    
    //MARK: -이동하는 뷰
    @ViewBuilder
    func otherViews(title:String) -> some View {
        switch title {
        case "달력" :
            calendar()
        case "제스쳐테스트":
            GestureTest()
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
            islandTest()
        case "스크롤" :
            scrollTest()
        default:
            Text("")
        }
    }
    
    //MARK: -연차 내용 뷰
    var dayOffView:some View {
        VStack(spacing:20){
            Text("내 연차 = ") + Text("\(String(format: "%.1f", myDayOff))일").foregroundColor(myDayOff > 7 ? .cyan : .red)
            HStack{
                commonBtn(title: "연차 사용", message: "연차를 사용하나요??") {
                    myDayOff -= 1
                }
                commonBtn(title: "반차 사용", message: "반차를 사용하나요??") {
                    myDayOff -= 0.5
                }
                commonBtn(title: "연차 수정", message: "입력한 내용으로 수정됩니다.") {
                    guard let num = Double(dayOffString)
                    else {
                        HapticManager.manager.notification(type: .error)
                        return
                    }
                    myDayOff = num
                }
            }
            .alert(alertContent.title, isPresented: $openAlert, presenting: alertContent) { text in
                if text.title == "연차 수정" {
                    TextField("숫자만 입력", text: $dayOffString).keyboardType(.numbersAndPunctuation)
                }
                Button("아니요") { print("") }
                Button("네") {
                    text.okAction()
                }
            } message: { text in
                Text(text.message)
            }
        }.frame(maxWidth: .infinity)
            .padding(.vertical,15)
            .background(Material.bar)
            .cornerRadius(15)
    }
    
    func commonBtn(title:String,message:String,action: @escaping () -> ()) -> some View {
        Button(title) {
            alertContent = .init(title:title,message: message,okAction: {
                action()
            })
            dayOffString = ""
            openAlert.toggle()
        }
    }
    
    func faceIDCHeck() {
        let context = LAContext()
        var error:NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "testApp"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    withAnimation {
                        isFaceID = true
                    }
                }else {
                    withAnimation {
                        isFaceID = false
                    }
                }
            }
        }else {
            isFaceID = true
            print("터치아이디,페이스아이디 없음")
        }
    }
}

struct AlertText {
    var title = ""
    var message = ""
    var okAction: () -> () = {}
}


