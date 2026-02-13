//
//  ScrollTest.swift
//  test0708
//
//  Created by khg on 2022/09/08.
//

import SwiftUI
import Combine
import AVFAudio

struct GaugeTest: View {
    
    @State private var batteryState:UIDevice.BatteryState = .unknown
    @State private var batteryLevel:Float = 0
    @State private var myAirPods = "연결안됨"
    @EnvironmentObject private var coreViewModel:CoreViewModel
    
    
    var body: some View {
        
        VStack(spacing:30){
            
            NavigationLink("test") {
                URLTest()
            }
            
            HStack{
                Text("내")
                Image(systemName: "airpodspro")
                Text("= \(myAirPods)")
            }.font(.largeTitle)
            
            HStack{
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
                    }
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(batteryState == .charging ? Color.green : Color.gray)
            }
            
            Button {
                withAnimation {
                    checkAudioBluetooth()
                }
            } label: {
                Text("확인")
            }
        }
        .task {
            withAnimation {
                myBattery()
                checkAudioBluetooth()
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
    
    func myBattery(){
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        batteryLevel = level < 0 ? 0 : level
    }
    
    func checkAudioBluetooth() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default,options: [.allowBluetoothHFP,.allowBluetoothA2DP])
        if let availableInputs = session.availableInputs {
            for i in availableInputs {
                if i.portType == .bluetoothHFP {
                    myAirPods = i.portName
                    print(i.portName)
                }
            }
        } else {
            myAirPods = "연결안됨"
        }
        
    }
    
}


