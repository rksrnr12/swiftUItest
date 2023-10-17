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
    @State private var testArray = -100...100
    var dayOfTheWeek = ["일","월","화","수","목","금","토"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Button("이전") {
                    withAnimation {
                        calendarID -= 1
                    }
                }
                
                Button(selectedDate.string(format: "yyyy년M월")) {
                    withAnimation {
                        calendarID = 0
                    }
                }
                
                Button("다음") {
                    withAnimation {
                        calendarID += 1
                    }
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
        }.onChange(of: calendarID) { _, newValue in
            withAnimation {
                selectedDate = Date().addMonth(n: newValue)
            }
        }
    }
}

extension Date {
    
    ///해당 월 총 일수
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
