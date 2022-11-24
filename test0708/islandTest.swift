//
//  islandTest.swift
//  test0708
//
//  Created by khg on 2022/10/07.
//

import SwiftUI
import ActivityKit

struct islandTest: View {
    
    @State private var test = Color(red: 0.98, green: 0.9, blue: 0.2)
    @State private var a = ""
    @State private var bool = false
    
    
    var body: some View {
        VStack {
            Text("")
            Button {
                test1()
            } label: {
                Text("시작")
                    .foregroundColor(test)
            }
            Button {
                test2()
            } label: {
                Text("업데이트")
            }
            Button {
                test3()
            } label: {
                Text("중단")
            }
        }
        .padding()
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
            let update = Attributes.ContentState(testname: "업데이트", testnum: 20)
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


