//
//  tabVIew.swift
//  test0708
//
//  Created by iquest on 2022/07/21.
//

import SwiftUI


struct tabVIew: View {
    
    @State var test:testSelect = .a
    
    enum testSelect:Int,CaseIterable{
        case a = 1
        case b = 2
    }
    
    
    
    
    var body: some View {
        VStack {
            TabView(selection: $test) {
                Text("1번").tag(testSelect.a)
                Text("2번").tag(testSelect.b)
            }.tabViewStyle(.page(indexDisplayMode: .always))
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
        }.frame(height: 200)
       
    }
}

struct tabVIew_Previews: PreviewProvider {
    static var previews: some View {
        tabVIew()
    }
}
