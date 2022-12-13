//
//  islandTest.swift
//  test0708
//
//  Created by khg on 2022/10/07.
//

import SwiftUI
import ActivityKit
import Combine

struct islandTest<content:View>: View {
    
    @State private var test = Color(red: 0.98, green: 0.9, blue: 0.2)
    @State private var time = 0
    @State private var text = "타이머 시작"
    @State private var bool = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var testView: (_ a:Int,_ b:Int) -> content

    
    var body: some View {
        VStack {
            testView(0, 1)
            Text("")
            Button {
                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                test1()
            } label: {
                Text("시작")
                    .foregroundColor(test)
            }
            Button {
                timer.upstream.connect().cancel()
                text = "타이머 중지"
            } label: {
                Text("중지")
            }
            Button {
                timer.upstream.connect().cancel()
                time = 0
                test3()
            } label: {
                Text("아일랜드 중단")
            }
        }
        .padding()
        .onReceive(timer) { out in
            print("여기")
            time += 1
            test2()
        }
    }
    
    func test1() {
        let testAttributes = Attributes(number: 1, total: "김한국")
        let testContentState = Attributes.ContentState(testname: "한국", testnum: 10)

        do {
            let testActivity = try Activity<Attributes>.request(attributes: testAttributes, contentState: testContentState,pushType: nil)
            print("다이나믹아일랜드 실행 \(testActivity.id)")
        }catch(let error){
            print(error.localizedDescription)
        }
    }

    func test2() {
        Task{
            let update = Attributes.ContentState(testname: text , testnum: time)
            for activity in Activity<Attributes>.activities{
                await activity.update(using: update)
            }
        }
    }

    func test3() {
        Task{
            for activity in Activity<Attributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
}


