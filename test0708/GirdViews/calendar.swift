//
//  calendar.swift
//  test0708
//
//  Created by iquest on 2022/07/20.
//

import SwiftUI

struct calendar: View {
    
    @State var selectedDate = Date()
    @State private var calendarID = 0
    @State private var startPoint:Int = -10
    @State private var endPoint:Int = 10
    @State private var testArray = -100...100
    var dayOfTheWeek = ["일","월","화","수","목","금","토"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Button {
                    withAnimation {
                        calendarID = calendarID - 1
                    }
                } label: {
                    Text("이전")
                }
                Text(selectedDate.string(format: "yyyy년M월"))
                Button {
                    withAnimation {
                        calendarID = calendarID + 1
                    }
                } label: {
                    Text("다음")
                }
            }
            HStack{
                ForEach(dayOfTheWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity, minHeight: 52 ,alignment: .center)
                        .foregroundColor(day == "일" ? .red : .white)
                        
                }
            }.border(.black, width: 1)
            TabView(selection:$calendarID) {
                ForEach(testArray,id: \.self) { num in
                    CalendarForScroll(num: num)
                        .tag(num)
                }
            }.frame(maxWidth: .infinity,maxHeight: 450)
                .tabViewStyle(.page(indexDisplayMode: .never))
        }.onChange(of: calendarID) { [calendarID] newValue in
            withAnimation {
                selectedDate = calendarID > newValue ? selectedDate.addMonth(n: -1) : selectedDate.addMonth(n: 1)
            }
        }
    }
}

extension Date {
    
    var daysInMonth:Int {
        let range = Calendar.current.range(of: .day , in: .month, for: self)
        return range?.count ?? 0
    }
    
    func addMonth(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: n, to: self)!
    }
    
    func string(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko")
        dateFormatter.calendar = .init(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
