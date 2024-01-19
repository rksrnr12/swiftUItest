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
                commonBtn(title: "이전", num: -1)
                commonBtn(title: selectedDate.string(format: "yyyy년M월"), num: 0)
                commonBtn(title: "다음", num: 1)
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
            }
            .frame(maxWidth: .infinity,maxHeight: 450)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .onChange(of: calendarID) { _,newValue in
            withAnimation {
                selectedDate = Date().addMonth(n: newValue)
            }
        }
    }
    
    func commonBtn(title:String,num:Int) -> some View {
        Button(title) {
            withAnimation {
                calendarID = num == 0 ? 0 : (calendarID + num)
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
    
    var startDay:Date {
        return self.dateChange(day: 1)
    }
    
    func string(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko")
        dateFormatter.calendar = .init(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    func int(format: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.calendar = .init(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    func dateChange(year:Int? = nil,month:Int? = nil,day:Int? = nil) -> Date {
        let dateComponents = DateComponents(
            year: year == nil ? self.int(format: "yyyy") : year,
            month:month == nil ? self.int(format: "MM") : month,
            day:day == nil ? self.int(format: "dd") : day
        )
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}
