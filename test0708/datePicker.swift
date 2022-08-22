//
//  datePicker.swift
//  test0708
//
//  Created by iquest on 2022/07/29.
//

import SwiftUI

struct datePicker: View {
    
    @State var date = Date()
    @State var open = false
    @State var open1 = false
    var body: some View {
        VStack(spacing:50){
        Text("open")
            .onTapGesture {
                open.toggle()
            }
            .sheet(isPresented: $open) {
                VStack{
                    DatePicker(selection: $date, displayedComponents: .date) {
                        Text("")
                    }.labelsHidden()
                    .datePickerStyle(.wheel)
                    .frame(height: 45)
                    .clipped()
                    Button {
                        print("123")
                    } label: {
                        Text("123")
                    }


                }
            }
            
            Text("2")
                .onTapGesture {
                    open1.toggle()
                }
                .sheet(isPresented: $open1) {
                    VStack{
                        DatePicker(selection: $date, displayedComponents: .date) {
                            Text("")
                        }.labelsHidden()
                        .datePickerStyle(.wheel)
                        //.frame(height: 45)
                        //.clipped()
                        Button {
                            print("123")
                        } label: {
                            Text("123")
                        }


                    }
                }
        }
//        VStack{
//            DatePicker(selection: $date, displayedComponents: .hourAndMinute) {
//                Text("")
//            }.labelsHidden()
//            .datePickerStyle(.wheel)
//            Button {
//                print("123")
//            } label: {
//                Text("123")
//            }
//
//
//        }
    }
}

struct datePicker_Previews: PreviewProvider {
    static var previews: some View {
        datePicker()
    }
}
