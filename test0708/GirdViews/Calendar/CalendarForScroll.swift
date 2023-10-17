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
    
    var body: some View {
        VStack(spacing: 0){
            ForEach(0..<6){ row in
                HStack(spacing: 0){
                    ForEach(1..<8){ column in
                        let count = column + (row * 7)
                        let day = count - start
                        if day < 1 {
                            //이전 달 출력
                            calendarDay(day: selectedDate.addMonth(n: num - 1).daysInMonth + day)
                        }else if (day > selectedDate.addMonth(n: num).daysInMonth) {
                            //다음 달 출력
                            calendarDay(day: day - selectedDate.addMonth(n: num).daysInMonth)
                        }else {
                            //현재 달 출력
                            calendarDay(day: day, color: column == 1 ? .red : .white)
                        }
                    }.border(.black, width: 0.5)
                }
            }
        }
    }
    
    func calendarDay(day:Int,color:Color = .gray) -> some View {
        Button {
            print(day)
        } label: {
            VStack(spacing: 0) {
                Text(String(day))
                    .frame(maxWidth: .infinity,minHeight: 65)
                    .foregroundStyle(color)
                if day == 10 {
                    Text("무언가")
                }
                Spacer()
            }
            
        }
        
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


