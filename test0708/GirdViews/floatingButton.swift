//
//  floatingButton.swift
//  test0708
//
//  Created by iquest on 2022/07/27.
//

import SwiftUI

struct floatingButton: View {
    
    @State var test:testSelect = .a
    
    enum testSelect:Int,CaseIterable{
        case a = 1
        case b = 2
    }
    
    var body: some View {
        ZStack{
            VStack {
                TabView(selection: $test) {
                    Text("1번")
                        .tag(testSelect.a)
                    Text("2번").tag(testSelect.b)
                }.tabViewStyle(.page(indexDisplayMode: .never))
                HStack{
                    Image(systemName: "circle.fill")
                        .resizable()
                        .foregroundColor(test == .a ? .yellow : .gray)
                        .frame(width: 8, height: 8)
                    Image(systemName: "circle.fill")
                        .resizable()
                        .foregroundColor(test == .b ? .yellow : .gray)
                        .frame(width: 8, height: 8)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(test == .a ? .white : .gray)
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        print("123")
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .background(Circle().frame(width: 54, height: 54).foregroundColor(.green))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 50))
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 4, x: 4, y: 4)
                            
                            
                    }
                }
            }
            
            
        }
    }
}

struct floatingButton_Previews: PreviewProvider {
    static var previews: some View {
        floatingButton()
    }
}
