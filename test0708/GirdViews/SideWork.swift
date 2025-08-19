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
    
    @StateObject private var viewModel = SideWorkViewModel()
    @FocusState private var focus:Bool
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL
    
    let completedColor = Color(red: 168/255, green: 230/255, blue: 207/255)
    let pendingColor = Color(red: 179/255, green: 229/255, blue: 152/255)
    
    var body: some View {
        VStack(spacing: 20) {
            topInfoView()
            mainListView()
        }
        .task {
            viewModel.getStepCountWithCoreMotion()
            viewModel.loadData()
        }
        .onChange(of: scenePhase) { old, newValue in
            if newValue == .active {
                viewModel.getStepCountWithCoreMotion()
                if viewModel.selection != .none {
                    viewModel.openAlert = true
                }
            }
        }
        .alert(viewModel.selection.rawValue + " 완료?", isPresented: $viewModel.openAlert) {
            TextField("가능하면 금액 입력", value: $viewModel.price, formatter: formatter)
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.trailing)
                .onSubmit {
                    viewModel.completedAction()
                    viewModel.openAlert = false
                }
            Button("아니요") {
                viewModel.selection = .none
            }
            Button("완료") {
                viewModel.completedAction()
            }
        }
        
    }
    
    func topInfoView() -> some View {
        HStack(spacing: 20) {
            Text("🚶‍♂️ : \(viewModel.todayWork.steps)")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.blue)
            Text("💰 : \(viewModel.totalPrice)원")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.green)
        }
    }
    
    ///메인 앱 이동 버튼, 상세 정보 리스트
    func mainListView() -> some View {
        ScrollView {
            VStack(alignment:.leading,spacing: 20) {
                HStack(alignment:.top,spacing: 15) {
                    commonListView(isAttendance: false)
                    commonListView(isAttendance: true)
                }
                
                DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                //.datePickerStyle(.graphical)
                
                priceListCell(item: viewModel.selectedTotalWork)
                
                //                LazyVStack(spacing: 20) {
                //                    ForEach(viewModel.totalWorkList) { item in
                //                        priceListCell(item: item)
                //                    }
                //                }
            }
            .padding(.horizontal,15)
            .animation(.default, value: viewModel.selectedDate)
        }
    }
    
    ///버튼 리스트
    func commonListView(isAttendance:Bool) -> some View {
        VStack(spacing: 20) {
            Text( isAttendance ? "✅ 출석체크" : "🏃 만보기" )
                .font(.headline)
            ForEach(isAttendance ? WorkType.attendanceList : WorkType.pedometerList ) { item in
                Button {
                    viewModel.selection = item
                    openURL(URL(string: item.scheme)!)
                } label: {
                    HStack {
                        Text(item.rawValue)
                        Spacer()
                        Image(systemName: viewModel.todayWork.workList.keys.contains(item) ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(.white)
                    }
                    .onLongPressGesture {
                        viewModel.selection = item
                        viewModel.openAlert = true
                    }
                }
                .buttonStyle(ColorButtonStyle(bgColor: viewModel.todayWork.workList.keys.contains(item) ? completedColor : pendingColor))
                
            }
        }
    }
    
    ///금액 상세
    func priceListCell(item:TodayWork) -> some View {
        VStack(alignment:.trailing,spacing:10) {
            HStack {
                Text("🗓️ \(item.savedDate.string(format: "yyyy년 MM월 dd일"))")
                Spacer()
                Text("🏃 \(item.steps)")
                    .foregroundStyle(.blue)
            }
            
            ForEach(Array(item.workList).sorted(by: { $0.value > $1.value }),id: \.key) { workType, price in
                if viewModel.selection == workType , !viewModel.openAlert {
                    HStack {
                        Text(workType.rawValue)
                        Spacer()
                        TextField("가능하면 금액 입력", value: $viewModel.price, formatter: formatter)
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                            .focused($focus)
                            .onSubmit {
                                if let index = viewModel.totalWorkList.firstIndex(where: { $0 == item }) {
                                    focus = false
                                    viewModel.totalWorkList[index].totalPrice -= price
                                    viewModel.editData(index: index, workType: workType)
                                }
                            }
                    }
                    .font(.system(size:14, weight: .regular))
                }else {
                    Button {
                        withAnimation {
                            viewModel.selection = workType
                            viewModel.price = price
                            focus = true
                        }
                    } label: {
                        HStack {
                            Text(workType.rawValue)
                            Spacer()
                            Text("\(price) 원")
                        }
                        .font(.system(size:14, weight: .regular))
                    }
                }
                
            }
            
            Text("합계 : \(item.totalPrice) 원")
        }
        .font(.system(size:14, weight: .semibold))
        .padding(.all,20)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))
    }
    
    
}

extension SideWork {
    var formatter:CustomNumberFormatter {
        let formatter = CustomNumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }
}
