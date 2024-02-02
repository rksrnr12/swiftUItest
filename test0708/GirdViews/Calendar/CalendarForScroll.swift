//
//  CalendarForScroll.swift
//  test0708
//
//  Created by khg on 2022/12/08.
//

import SwiftUI

struct CalendarForScroll: View {
    
    @AppStorage("calendarEvent") private var event:Data?
    @State private var eventList:[Crossfit] = []
    @State private var sheetItem:Crossfit = .init()
    @State private var sheetSize = PresentationDetent.height(200)
    @State private var testBool = false
    var selectedDate = Date()
    var num:Int
    
    var body: some View {
        VStack(spacing: 0){
            ForEach(0..<6){ row in
                HStack(spacing: 0){
                    ForEach(1..<8){ column in
                        let count = column + (row * 7)
                        let day = count - start
                        if day < 1 {
                            //이전 달 출력
                            calendarDay(day: selectedDate.addMonth(n: num - 1).daysInMonth + day,addMonth: (num - 1))
                        }else if (day > selectedDate.addMonth(n: num).daysInMonth) {
                            //다음 달 출력
                            calendarDay(day: day - selectedDate.addMonth(n: num).daysInMonth,addMonth: num)
                        }else {
                            //현재 달 출력
                            calendarDay(day: day,addMonth: 0,color: column == 1 ? .red : .white)
                        }
                    }.border(.black, width: 0.5)
                }
            }
        }
        .sheet(isPresented: $testBool) {
            //bool타입으로 시트를 올려야지 Detents에서 selection이 제대로 작동함
            dataInputView(item: sheetItem)
                .presentationDetents([.medium,.height(200)],selection:$sheetSize)
        }
        .task {
            guard let savedEvent = event else { return }
            guard let array = try? JSONDecoder().decode([Crossfit].self, from: savedEvent) else { return }
            eventList = array
        }
        
        
    }
    
    ///달력 셀
    func calendarDay(day:Int, addMonth:Int, color:Color = .gray) -> some View {
        Button {
            let dateString = selectedDate.addMonth(n: addMonth).dateChange(day: day).string(format: "yy/MM/dd")
            sheetItem = .init(date:dateString)
            testBool.toggle()
        } label: {
            VStack(spacing: 5) {
                Text(String(day))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(color)
                if compareDate(day: day, addMonth: addMonth) {
                    Text("test")
                        .font(.footnote)
                }
                Spacer()
            }
        }
    }
    
    func dataInputView(item:Crossfit) -> some View {
        VStack(spacing: 20) {
            commonTextView(title: "날짜", detail: item.date)
            commonTextView(title: "운동타임", detail: item.time)
            commonTextView(title: "운동내용", detail: item.memo)
        }.padding(.horizontal,20)
    }
    
    func commonTextView(title:String,detail:String) -> some View {
        HStack {
            Text(title)
                .onTapGesture {
                    print(sheetSize)
                }
            Spacer()
            Text(detail)
        }
        
    }
}

extension CalendarForScroll {
    
    ///요일 배열
    func dayArray() -> [CalendarArray] {
        let before = Calendar.current.component(.weekday, from: selectedDate.startDay) - 1
        let current = (Calendar.current.range(of: .day, in: .month, for: selectedDate) ?? 1..<30).map { String($0) }
        let result = .init(repeating: "", count: before) + current
        return result.map { CalendarArray(day: $0) }
    }
    
    
    struct CalendarArray:Hashable,Identifiable{
        var day:String
        var id:UUID = UUID()
    }
    
    
    func compareDate(day:Int, addMonth:Int) -> Bool {
        let calendarDate = selectedDate.addMonth(n: addMonth).dateChange(day: day).string(format: "yy/MM/dd")
        return eventList.map(\.date).contains(calendarDate)
    }
    
    var firstDayOfMonth:Date {
        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate.addMonth(n: num))
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var startingSpaces:Int {
        let components = Calendar.current.dateComponents([.weekday], from: firstDayOfMonth)
        return (components.weekday ?? 0) - 1
    }
    var start:Int {
        startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
    }
}

struct Crossfit:Codable,Identifiable {
    var date = ""
    var time = ""
    var memo = ""
    
    var id:UUID { UUID() }
}


