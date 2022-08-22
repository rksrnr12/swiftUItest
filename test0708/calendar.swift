//
//  calendar.swift
//  test0708
//
//  Created by iquest on 2022/07/20.
//

import SwiftUI

struct calendar: View {
    
    @State var selectedDate = Date()
    
    var dayOfTheWeek = ["일","월","화","수","목","금","토"]
    
    var daysInMonth:Int {
        let range = Calendar.current.range(of: .day , in: .month, for: selectedDate)
        return range?.count ?? 0
    }
    
    var firstDayOfMonth:Date {
        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var startingSpaces:Int {
        let components = Calendar.current.dateComponents([.weekday], from: firstDayOfMonth)
        return (components.weekday ?? 0) - 1
    }
    var start:Int {
        startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
    }
    
    func addMonth(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: n, to: selectedDate)!
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Text("이전")
                    .onTapGesture {
                        selectedDate = addMonth(n: -1)
                    }
                Text("다음")
                    .onTapGesture {
                        selectedDate = addMonth(n: 1)
                    }
            }
            HStack{
                ForEach(dayOfTheWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity, minHeight: 52 ,alignment: .center)
                        
                }
            }.border(.black, width: 1)
            VStack(spacing: 0){
                ForEach(0..<6){ row in
                    HStack(spacing: 0){
                        ForEach(1..<8){ column in
                            let count:Int = column + (row * 7)
                            let day:Int = count - start
                            let endDay = count - start - daysInMonth
                            if day < 1 || (day > daysInMonth){
                                if (start == 7 && day < 1)  {
                                    
                                }else if row == 5 && endDay > 1 {
                                    
                                }else{
                                    Text("")
                                        .frame(maxWidth: .infinity, minHeight: 65, alignment: .top)
                                }
                            }else{
                                Text(String(day))
                                    .frame(maxWidth: .infinity, minHeight: 65, alignment: .top)
                                    .onTapGesture {
                                        print(endDay)
                                    }
                            }
                        }.border(.black, width: 0.5)
                        
                    }
                }
            }
        }.animation(.easeInOut, value: start)
    }
}

struct calendar_Previews: PreviewProvider {
    static var previews: some View {
        calendar()
    }
}
