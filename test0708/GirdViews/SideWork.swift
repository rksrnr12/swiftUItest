//
//  SideWork.swift
//  test0708
//
//  Created by khg on 6/24/24.
//

import SwiftUI
import HealthKit
import CoreMotion

struct SideWork: View {
    
    @AppStorage("CompletionList") private var completionList:Data?
    @AppStorage("SavedDate") private var savedDate:String = ""
    @AppStorage("TotalPrice") private var totalPrice:Int = 0
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL
    @FocusState private var focus:Int?
    @State private var healthData = HKHealthStore()
    @State private var motionData = CMPedometer()
    @State private var selection:WorkType = .none
    @State private var workList:[WorkType] = []
    @State private var stepCount = ""
    @State private var price = ""
    @State private var openAlert = false
    @State private var changePrice = false
    
    let completedColor = Color(red: 168/255, green: 230/255, blue: 207/255)
    let pendingColor = Color(red: 179/255, green: 229/255, blue: 152/255)
    
    var formatter:NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("🚶‍♂️ 오늘 걸음수: \(stepCount)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.blue)
                totalPriceView()

                HStack(alignment:.top,spacing: 15) {
                    commonListView(isAttendance: false)
                    commonListView(isAttendance: true)
                }
            }
            .padding(.horizontal,15)
        }
        .task {
            getStepCountWithCoreMotion()
            guard let list = completionList else { return }
            workList = (try? JSONDecoder().decode([WorkType].self, from: list)) ?? []
            if Date().string(format: "yyMMdd") != savedDate {
                withAnimation {
                    workList = []
                    completionList = nil
                }
            }
        }
        .onChange(of: scenePhase) { old, newValue in
            if newValue == .active {
                getStepCountWithCoreMotion()
                if selection != .none {
                    openAlert = true
                }
            }
        }
        .alert(selection.rawValue + " 완료?", isPresented: $openAlert) {
            TextField("가능하면 금액 입력", text: $price)
                .keyboardType(.numbersAndPunctuation)
            Button("아니요") { print("") }
            Button("완료") {
                withAnimation {
                    if workList.isEmpty {
                        savedDate = Date().string(format: "yyMMdd")
                    }
                    workList.append(selection)
                    totalPrice += Int(price) ?? 0
                    completionList = try? JSONEncoder().encode(workList)
                    selection = .none
                    price = ""
                }
            }
        }
    }
    
    @ViewBuilder
    func totalPriceView() -> some View {
        if changePrice {
            HStack(spacing:0) {
                Text("💰 예상 수익: ")
                TextField("", value: $totalPrice, formatter: formatter)
                    .frame(width:100)
                    .accentColor(.green)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: 1)
                Text("원")
            }
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(.green)
            .onChange(of: focus) { _, newValue in
                if newValue == nil {
                    withAnimation {
                        changePrice = false
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("완료") {
                            focus = nil
                        }
                        .foregroundStyle(.blue)
                    }
                    
                }
            }
        }else {
            Button {
                changePrice = true
                focus = 1
            } label: {
                Text("💰 예상 수익: \(totalPrice)원")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.green)
            }
        }
    }
    
    func commonListView(isAttendance:Bool) -> some View {
        VStack(spacing: 20) {
            Text( isAttendance ? "✅ 출석체크" : "🏃 만보기" )
                .font(.headline)
            ForEach(checkList(isAttendance: isAttendance)) { item in
                Button {
                    selection = item
                    openURL(URL(string: item.scheme)!)
                } label: {
                    HStack {
                        Text(item.rawValue)
                        Spacer()
                        Image(systemName: workList.contains(item) ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(ColorButtonStyle(bgColor: workList.contains(item) ? completedColor : pendingColor))
            }
        }
    }
    
    func checkList(isAttendance:Bool) -> [WorkType] {
        isAttendance ? WorkType.attendanceList : WorkType.pedometerList
    }
    
    func getStepCountWithHealthKit() {
        let startDay = Calendar.current.startOfDay(for: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startDay, end: Date(), options: .strictStartDate)
        let data = HKStatisticsQuery(quantityType: .init(.stepCount), quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            print(query)
            guard let count = result?.sumQuantity() else { return }
            print(count)
        }
        healthData.execute(data)
    }
    
    func getStepCountWithCoreMotion() {
        let startDay = Calendar.current.startOfDay(for: Date())
        guard CMPedometer.isStepCountingAvailable() else { return }
        motionData.queryPedometerData(from: startDay, to: Date()) { data, error in
            if let steps = data?.numberOfSteps {
                withAnimation {
                    stepCount = steps.stringValue
                }
            }
        }
    }
    
    
    
}

extension SideWork {
    enum WorkType:String,CaseIterable,Identifiable,Codable {
        case toss = "토스"
        case kakaoBank = "카카오뱅크"
        case kBank = "케이뱅크"
        case naverPay = "네이버페이"
        case shinhanSol = "신한쏠"
        case kakaoPay = "카카오페이"
        case hanaCard = "하나카드"
        case wooriWon = "우리원"
        case cashWalk = "캐시워크"
        case hanaMoney = "하나머니"
        case seoul9988 = "손목닥터9988"
        case payBooc = "페이북"
        case IBK = "IBK"
        case none = ""
        
        var id:UUID { UUID() }
        
        var scheme:String {
            switch self {
            case .toss:
                "supertoss://"
            case .kakaoBank:
                "kakaobank://"
            case .kBank:
                "ukbanksmartbankweb://"
            case .naverPay:
                //shortcuts://run-shortcut?name=[이름]&input=[입력]&text=[텍스트]
                "shortcuts://run-shortcut?name=네이버페이"
            case .shinhanSol:
                "smailapp://"
            case .kakaoPay:
                "kakaopay://"
            case .hanaCard:
                "shortcuts://run-shortcut?name=하나카드"
            case .wooriWon:
                "wooribank://"
            case .cashWalk:
                "cashwalkapp://"
            case .hanaMoney:
                "hanawalletmembers://"
            case .seoul9988:
                "shortcuts://run-shortcut?name=손목닥터"
            case .payBooc:
                "ispmobile://"
            case .IBK:
                "shortcuts://run-shortcut?name=ibk"
            default:
                ""
            }
        }
        
        static let attendanceList:[WorkType] = [.kBank,.naverPay,.hanaCard,.wooriWon,.hanaMoney,.payBooc,.IBK]
        static let pedometerList:[WorkType] = [.toss,.kakaoBank,.shinhanSol,.kakaoPay,.cashWalk,.seoul9988]
        
        
    }
}
