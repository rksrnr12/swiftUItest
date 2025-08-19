//
//  SideWorkViewModel.swift
//  test0708
//
//  Created by khg on 4/2/25.
//

import Foundation
import HealthKit
import CoreMotion
import SwiftUI

@MainActor
final class SideWorkViewModel:ObservableObject {
    
    @AppStorage("TotalWorkList") var totalWorkData:Data?
    ///건강앱 데이터
    @Published var healthData = HKHealthStore()
    ///핸드폰만 적용되는 걸음수
    @Published var motionData = CMPedometer()
    ///예상 금약
    @Published var price = 0
    ///알림 오픈
    @Published var openAlert = false
    ///금액 입력 변경
    @Published var changePrice = false
    ///전체 등록된 정보
    @Published var totalWorkList:[TodayWork] = []
    ///오늘 등록된 정보
    @Published var todayWork:TodayWork = .init()
    ///선택한 버튼 타입
    @Published var selection:WorkType = .none
    ///상세 날짜
    @Published var selectedDate = Date()
//    ///알림 팝업
//    @Published var openAlert:AlertType? = nil
    
    ///총금액
    var totalPrice:Int {
        totalWorkList.map {$0.totalPrice}.reduce(0,+)
    }
    
    ///선택된 리스트
    var selectedTotalWork:TodayWork {
        totalWorkList.first { Calendar.current.isDate(selectedDate, inSameDayAs: $0.savedDate) } ?? .init()
    }

    ///건강앱 데이터 조회
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
    
    ///핸드폰 정보만 조회
    func getStepCountWithCoreMotion() {
        let startDay = Calendar.current.startOfDay(for: Date())
        guard CMPedometer.isStepCountingAvailable() else { return }
        motionData.queryPedometerData(from: startDay, to: Date()) { data, error in
            if let steps = data?.numberOfSteps {
                DispatchQueue.main.async {
                    withAnimation {
                        self.todayWork.steps = steps.stringValue
                        self.saveData()
                    }
                }
            }
        }
    }
    
    ///금액 입력 액션
    func completedAction() {
        withAnimation {
            todayWork.totalPrice += price
            if todayWork.workList.keys.contains(selection) {
                todayWork.workList[selection]! += price
            }else {
                todayWork.workList[selection] = price
            }
            saveData()
            selection = .none
            price = 0
        }
    }
    
    func editData(index:Int,workType:WorkType) {
        totalWorkList[index].totalPrice += price
        totalWorkList[index].workList[workType] = price
        saveData(isEdit: true)
        selection = .none
        price = 0
    }
    
    ///데이터 저장
    func saveData(isEdit:Bool = false) {
        if !isEdit {
            if let num = totalWorkList.firstIndex(where: {Calendar.current.isDateInToday($0.savedDate)}) {
                totalWorkList[num] = todayWork
            }else {
                totalWorkList.append(todayWork)
            }
        }
        guard let data = try? JSONEncoder().encode(totalWorkList) else { return }
        totalWorkData = data
    }
    
    ///데이터 불러오기
    func loadData() {
        guard let data = totalWorkData else { return }
        guard let list = try? JSONDecoder().decode([TodayWork].self, from: data) else { return }
        totalWorkList = list
        if let currentList = totalWorkList.first(where: { Calendar.current.isDateInToday($0.savedDate) }) {
            todayWork = currentList
        }
    }
    
}

extension SideWorkViewModel {
    enum AlertType:Int,Identifiable {
        case price
        case edit
        
        var id:Int { rawValue }
    }
}
