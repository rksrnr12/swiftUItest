//
//  ContentView.swift
//  test0708
//
//  Created by iquest on 2022/07/08.
//

import SwiftUI
import Foundation
import LocalAuthentication
import StoreKit
//import BtnStyle


struct ContentView: View {
    
    @AppStorage("arrayData") var arrayData:Data?
    @AppStorage("myDayOff") var myDayOff = 2.5
    @StateObject private var gridViewModel = DropGridViewModel()
    @EnvironmentObject private var coreViewModel:CoreViewModel
    @State private var dayOffString = ""
    @State private var openAlert = false
    @State private var isFaceID = false
    @State private var alertContent:AlertText = .init()
    @State private var gridColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State private var gridCount = 3
    @State private var alertID = 0
    @State private var alertCount = 0
    @State private var selection:Grid? = nil
    @Namespace var testName
    @State private var popoverTest = false
    
    var body: some View {
        VStack{
            if isFaceID {
                mainView()
                    .highPriorityGesture(
                        magnify
                    )
            }else {
                Spacer()
                Button("로그인 다시시도") {
                    faceIDCHeck()
                }
//                confirmButton(title: "test") {
//                    print("test")
//                }
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem {
                Button("숨기기") {
                    withAnimation {
                        isFaceID = false
                    }
                }
            }
//            ToolbarItem(placement: .bottomBar) {
//                testBottomBar()
//            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("alert"))) { _ in
            Task {
                alertCount = await UNUserNotificationCenter.current().deliveredNotifications().count
            }
        }
        .task {
            if isFaceID == false {
                faceIDCHeck()
            }
            
            guard let savedData = arrayData else {
                guard let data = try? JSONEncoder().encode(gridViewModel.gridItems) else { return }
                arrayData = data
                return
            }
            guard let array = try? JSONDecoder().decode([Grid].self, from: savedData) else { return }
            if gridViewModel.compareGrid(saved: array) {
                gridViewModel.gridItems = array
            }
        }
        .navigationDestination(for: Grid.self) { value in
            otherViews(title: value.gridText)
                .navigationTransition(.zoom(sourceID: value.id, in: testName))
                .onAppear {
                    print(coreViewModel.naviStack)
                }
        }
//        .navigationDestination(item: $selection) { grid in
//            otherViews(title: grid.gridText)
//                .navigationTransition(.zoom(sourceID: grid.id, in: testName))
//        }
    }
    
    func mainView() -> some View {
        ScrollView {
            LazyVStack(pinnedViews:.sectionHeaders) {
                Section(header: dayOffView) {
                    LazyVGrid(columns: gridColumns) {
                        ForEach(gridViewModel.gridItems) { grid in
                            NavigationLink(value: grid) {
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
                            }
                            .buttonStyle(.pushAnimation)
                            .matchedTransitionSource(id: grid.id, in: testName)
//                            Button {
//                                selection = grid
//                            } label: {
//                                RoundedRectangle(cornerRadius: 25)
//                                    .frame(maxWidth: .infinity,minHeight: 100)
//                                    .foregroundColor(Color(red: grid.number, green: grid.number2, blue: grid.number3))
//                                    .overlay {
//                                        Text(grid.gridText)
//                                            .foregroundColor(.white)
//                                    }
//                                    .onDrag ({
//                                        HapticManager.manager.notification(type: .success)
//                                        gridViewModel.currentGrid = grid
//                                        return NSItemProvider(object: String(grid.gridText) as NSString)
//                                    })
//                                    .onDrop(of: [.text], delegate: DropViewDelegate(gird: grid, gridData: gridViewModel))
//                            }
//                            .buttonStyle(.pushAnimation)
//                            .matchedTransitionSource(id: grid.id, in: testName)
                        }
                    }
                    .padding(.horizontal,5)
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
        case "웹뷰" :
            webViewTest()
        case "차트":
            chartTest()
        case "부업":
            SideWork()
        default:
            Text("")
        }
    }
    
    
    
    //MARK: -연차 내용 뷰
    var dayOffView:some View {
        VStack(spacing:20){
            Text("내 연차 = ") + Text("\(String(format: "%.1f", myDayOff))일").foregroundColor(myDayOff > 7 ? .cyan : .red)
            Text("\(alertCount)")
//            Text("test")
//                .foregroundStyle(.blue)
//                .onTapGesture {
//                    popoverTest.toggle()
//                }
//                .popover(isPresented: $popoverTest) {
//                    VStack {
//                        Button("test1") {
//                            popoverTest.toggle()
//                        }
//                    }
//                    //.background(Color.green)
//                    .presentationCompactAdaptation(.popover)
//                    .presentationBackground {
//                        Color.green
//                    }
//                }
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
                Button("알림") {
                    let notiCenter = UNUserNotificationCenter.current()
                    notiCenter.getNotificationSettings { item in
                        if item.authorizationStatus != .authorized {
//                            openURL(URL(string: UIApplication.openSettingsURLString)!)
                        }else {
                            alertID += 1
                            let localNoti = UNMutableNotificationContent()
                            localNoti.title = "알림"
                            localNoti.body = "할말없음"
                            localNoti.sound = .default
                            localNoti.badge = 1
                            
                            
                            var date = DateComponents()
                            date.hour = 16
                            date.minute = 9
                            
                            //                    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                            let request = UNNotificationRequest(identifier: "test" + "\(alertID)", content: localNoti, trigger: trigger)
                            UNUserNotificationCenter.current().add(request)
                        }
                    }
                }
                Button("확인") {
                    Task {
                        let noti = await UNUserNotificationCenter.current().deliveredNotifications()
                        print(noti)
                        alertCount = noti.count
                    }
                }
                Button("지우기") {
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    UNUserNotificationCenter.current().setBadgeCount(0) { _ in }
                    alertCount = 0
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
            .animation(.default, value: myDayOff)
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
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    withAnimation {
                        isFaceID = true
                    }
                }else {
                    //                    withAnimation {
                    //                        isFaceID = false
                    //                    }
                }
            }
        }else {
            withAnimation {
                isFaceID = true
            }
            print("터치아이디,페이스아이디 없음")
        }
    }
    
    var magnify: some Gesture {
        MagnifyGesture()
            .onChanged{ value in
                withAnimation {
                    switch value.magnification {
                    case 0.1...0.5 :
                        if gridCount < 9 {
                            gridColumns = Array(repeating: .init(.flexible()), count: gridCount + 2)
                        }
                    case 0.5...1 :
                        if gridCount < 10 {
                            gridColumns = Array(repeating: .init(.flexible()), count: gridCount + 1)
                        }
                    case 1...1.5 :
                        gridColumns = Array(repeating: .init(.flexible()), count: gridCount)
                    case 1.5...2 :
                        if gridCount > 1 {
                            gridColumns = Array(repeating: .init(.flexible()), count: gridCount - 1)
                        }
                    case 2... :
                        if gridCount > 2 {
                            gridColumns = Array(repeating: .init(.flexible()), count: gridCount - 2)
                        }
                    default:
                        break
                    }
                }
            }
            .onEnded { value in
                switch value.magnification {
                case 0.1...0.5 :
                    if gridCount < 9 {
                        gridCount += 2
                    }
                case 0.5...1 :
                    if gridCount < 10 {
                        gridCount += 1
                    }
                case 1...1.5 :
                    gridCount = gridCount
                case 1.5...2 :
                    if gridCount > 1 {
                        gridCount -= 1
                    }
                case 2... :
                    if gridCount > 2 {
                        gridCount -= 2
                    }
                default:
                    break
                }
            }
    }
    
    func testBottomBar() -> some View {
        HStack {
            Menu {
                Button("이름 어디까지 길어지나요") {
                    print("1")
                }
                Button("이름이 엄청 길어지면 과연 어떻게 될까요?") {
                    print("1")
                }
                Button("이름이 그냥 끝이 없으면 어떻게 될까요 하하 이거보다 더 길어지면 어떻게 될까요?") {
                    print("1")
                }
            } label: {
                Text("버튼1")
            }
            Spacer()
            Menu {
                Button("이름 어디까지 길어지나요") {
                    print("1")
                }
                Button("이름이 엄청 길어지면 과연 어떻게 될까요?") {
                    print("1")
                }
                Button("이름이 그냥 끝이 없으면 어떻게 될까요 하하 이거보다 더 길어지면 어떻게 될까요?") {
                    print("1")
                }
            } label: {
                Text("버튼2")
            }
            Spacer()
            Menu {
                Button("이름 어디까지 길어지나요") {
                    print("1")
                }
                Button("이름이 엄청 길어지면 과연 어떻게 될까요?") {
                    print("1")
                }
                Button("이름이 그냥 끝이 없으면 어떻게 될까요 하하 이거보다 더 길어지면 어떻게 될까요?") {
                    print("1")
                }
            } label: {
                Text("버튼3")
            }
            Spacer()
            Menu {
                Button("이름 어디까지 길어지나요") {
                    print("1")
                }
                Button("이름이 엄청 길어지면 과연 어떻게 될까요?") {
                    print("1")
                }
                Button("이름이 그냥 끝이 없으면 어떻게 될까요 하하 이거보다 더 길어지면 어떻게 될까요?") {
                    print("1")
                }
            } label: {
                Text("버튼4")
            }
            Spacer()
            Menu {
                Button("이름 어디까지 길어지나요") {
                    print("1")
                }
                Button("이름이 엄청 길어지면 과연 어떻게 될까요?") {
                    print("1")
                }
                Button("이름이 그냥 끝이 없으면 어떻게 될까요 하하 이거보다 더 길어지면 어떻게 될까요?") {
                    print("1")
                }
            } label: {
                Text("버튼5")
            }
        }
    }
}

struct AlertText {
    var title = ""
    var message = ""
    var okAction: () -> () = {}
}


struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(configuration.isPressed ? .blue : .red)
            .background(Color(configuration.isPressed ? .gray : .yellow))
            .opacity(configuration.isPressed ? 1 : 0.75)
            //.clipShape(Capsule())
    }
}


//앱스토어 시트
func presentAppStore(appID: String) {
    guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first else { return }
    let storeVC = SKStoreProductViewController()
    let params = [SKStoreProductParameterITunesItemIdentifier: appID]
    storeVC.loadProduct(withParameters: params) { loaded, error in
        if loaded {
            window.rootViewController?.present(storeVC, animated: true)
        }
    }
}
