//
//  CalendarForScroll.swift
//  test0708
//
//  Created by khg on 2022/12/08.
//

import SwiftUI

struct CalendarForScroll: View {
    
    var selectedDate = Date()
    var num:Int
    
    
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
    
    
    
    
    var body: some View {
        VStack(spacing: 0){
            ForEach(0..<6){ row in
                HStack(spacing: 0){
                    ForEach(1..<8){ column in
                        let count:Int = column + (row * 7)
                        let day:Int = count - start
                        if day < 1 || (day > selectedDate.addMonth(n: num).daysInMonth){
                            if day < 1 {
                                let prevMonth = selectedDate.addMonth(n: num - 1).daysInMonth + day
                                Text(String(prevMonth))
                                    .frame(maxWidth: .infinity,minHeight: 65,alignment: .top)
                                    .foregroundColor(.gray)
                            }else{
                                let nextMonth = day - selectedDate.addMonth(n: num).daysInMonth
                                Text(String(nextMonth))
                                    .frame(maxWidth: .infinity,minHeight: 65,alignment: .top)
                                    .foregroundColor(.gray)
                            }
                        }else{
                            Text(String(day))
                                .frame(maxWidth: .infinity, minHeight: 65, alignment: .top)
                                .foregroundColor(column == 1 ? .red : .white)
                        }
                    }.border(.black, width: 0.5)
                }
            }
        }
    }
}


