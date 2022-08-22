//
//  BarChart.swift
//  test0708
//
//  Created by iquest on 2022/07/20.
//

import SwiftUI

struct BarChart: View {
    
    @State var height:CGFloat = 30
    @State var doubleNum:Double = 10.5
    
    var body: some View {
        
        VStack {
            HStack(alignment:.bottom){
                VStack{
                    Capsule().frame(width: 30, height: height)
                    Text("1번")
                }
                VStack{
                    Capsule().frame(width: height, height: 30)
                    Text("2번")
                }
            }
                
            Text("늘리기")
                .onTapGesture {
                    height = 150
                    doubleNum = 200
                }
            Text("줄이기")
                .onTapGesture {
                    height = 80
                    doubleNum = 130
                }
        }.animation(.spring(dampingFraction: 0.5).speed(2), value: height)
    }
}



struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart()
    }
}
