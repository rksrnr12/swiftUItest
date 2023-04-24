//
//  islandTest.swift
//  test0708
//
//  Created by khg on 2022/10/07.
//

import SwiftUI
import ActivityKit
import Combine

struct islandTest: View {
    
    @State private var test = Color(red: 0.98, green: 0.9, blue: 0.2)
    @State private var time = 0
    @State private var text = "타이머 시작"
    @State private var bool = false
    @State private var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        VStack {
            Text("")
            Button {
                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                startActivity()
            } label: {
                Text("시작")
                    .foregroundColor(test)
            }
            Button {
                timer.upstream.connect().cancel()
                updateActivity()
                text = "타이머 중지"
            } label: {
                Text("중지")
            }
            Button {
                timer.upstream.connect().cancel()
                time = 0
                endActivity()
            } label: {
                Text("아일랜드 중단")
            }
        }
        .padding()
        .onReceive(timer) { out in
            print("여기")
            time += 1
            updateActivity()
        }
    }
    
    func startActivity() {
        let contentState = Attributes.ContentState(testname: "시작", testnum: 10)
        let activityAttributes = Attributes(number: 2, total: "시작")
        let activityContent = ActivityContent(state: contentState, staleDate: .distantFuture)
        
        do {
            let activity = try Activity<Attributes>
                .request(attributes: activityAttributes, content: activityContent)
//                .request(attributes: activityContent, contentState: contentState,pushType: nil)
            print("다이나믹아일랜드 실행 \(activity.id)")
        }catch(let error){
            print(error.localizedDescription)
        }
    }

    func updateActivity() {
        let update = Attributes.ContentState(testname: text , testnum: time)
        let activityContent = ActivityContent(state: update, staleDate: .distantFuture)
        Task{
            for activity in Activity<Attributes>.activities{
                await activity
                    .update(activityContent)
//                    .update(using: update)
            }
        }
    }

    func endActivity() {
        let end = Attributes.ContentState(testname: "끝", testnum: 1)
        let activityContent = ActivityContent(state: end, staleDate: .distantFuture)
        Task{
            for activity in Activity<Attributes>.activities{
                await activity
                    .end(activityContent,dismissalPolicy: .default)
//                    .end(dismissalPolicy: .immediate)
            }
        }
    }
}


