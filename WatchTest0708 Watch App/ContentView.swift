//
//  ContentView.swift
//  WatchTest0708 Watch App
//
//  Created by khg on 2023/05/03.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    
    @State private var batteryState:WKInterfaceDeviceBatteryState = .unknown
    @State private var batteryLevel:Float = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    NavigationLink {
                        NewWatchView()
                            .navigationTitle("이동한 뷰")
                    } label: {
                        Text("이동하기")
                            .foregroundColor(.green)
                    }
                    Text("test")
                    
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
                            HStack {
                                Image(systemName: "applewatch")
                                Text(String(Int(batteryLevel * 100)))
                            }
                            
                        }
                    }.gaugeStyle(.accessoryCircularCapacity)
                        .tint(batteryState == .charging ? Color.green : Color.gray)
                }
            }.navigationTitle("처음화면")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
                    batteryLevel = WKInterfaceDevice.current().batteryLevel
                }
        }
    }
    
}
