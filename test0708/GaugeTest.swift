//
//  ScrollTest.swift
//  test0708
//
//  Created by khg on 2022/09/08.
//

import SwiftUI

struct GaugeTest: View {
    
    @State private var test:Double = 1
    @State private var batteryState:UIDevice.BatteryState = .unknown
    @State private var batteryLevel:Float = 0
    
    func myBattery(){
        UIDevice.current.isBatteryMonitoringEnabled = true
        batteryLevel = UIDevice.current.batteryLevel
    }
    
    var body: some View {
        VStack(spacing:30){
            HStack{
                Gauge(value: test,in:0...100) {
                    Text("")
                } currentValueLabel: {
                    Image(systemName: "airpodspro")
                }.gaugeStyle(.accessoryCircularCapacity)
                
                Gauge(value: batteryLevel,in:0...1) {
                    Text("")
                } currentValueLabel: {
                    if batteryState == .charging {
                        HStack(spacing:0){
                            Text(String(Int(batteryLevel * 100)))
                            Image(systemName: "bolt.fill")
                                .font(.footnote)
                        }
                    }else{
                        Image(systemName: "iphone.gen3")
                          // .font(.title2)
                    }
                }.gaugeStyle(.accessoryCircularCapacity)
                    .tint(Color.green)
                
                Gauge(value: test,in:0...100) {
                    Text("")
                } currentValueLabel: {
                    Image(systemName: "ipad")
                }.gaugeStyle(.accessoryCircularCapacity)
                
                Gauge(value: test,in:0...100) {
                    Text("")
                } currentValueLabel: {
                    Image(systemName: "applewatch")
                }.gaugeStyle(.accessoryCircularCapacity)
                
                
                
            }
            HStack{
                Button {
                    if test < 100{
                        test += 1
                    }
                    print(test)
                } label: {
                    Text("더하기")
                }
                Button {
                    if test > 0{
                        test -= 1
                    }
                    print(test)
                } label: {
                    Text("빼기")
                }
            }
        }.animation(.default, value: test)
            .onAppear {
                withAnimation {
                    myBattery()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryStateDidChangeNotification)) { _ in
                withAnimation {
                    batteryState = UIDevice.current.batteryState
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification)) { _ in
                withAnimation {
                    myBattery()
                }
            }
    }
}
