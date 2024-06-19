//
//  chartTest.swift
//  test0708
//
//  Created by khg on 6/11/24.
//

import SwiftUI
import Charts

struct chartTest: View {
    
    let data = [
            (name: "Cachapa", sales: 916),
            (name: "Injera", sales: 850),
            (name: "Crêpe", sales: 802),
            (name: "Jian Bing", sales: 753),
            (name: "Dosa", sales: 654),
            (name: "American", sales: 618)
            
        ]
    
    var body: some View {
        barChart
    }
    
    var barChart: some View {
        VStack {
            Chart(data,id: \.name) { item in
                //x,y 값의 따라 방향이 달라짐
                BarMark(
                    x: .value("Name", item.name),
                    y: .value("Sales", item.sales)
                )
                .foregroundStyle(.green)
                .clipShape(RoundedRectangle(cornerRadius: 10))
    //            .accessibilityLabel(item.name)
    //            .accessibilityValue("\(item.sales) sold")
            }
            .padding(.all,10)
            
            Chart(data,id: \.name) { item in
                BarMark(
                    x: .value("Sales", item.sales),
                    y: .value("Name", item.name)
                )
                .foregroundStyle(.green)
    //            .accessibilityLabel(item.name)
    //            .accessibilityValue("\(item.sales) sold")
            }
            .padding(.all,10)
        }
    }
}

#Preview {
    chartTest()
}
