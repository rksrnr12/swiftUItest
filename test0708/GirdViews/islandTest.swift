//
//  islandTest.swift
//  test0708
//
//  Created by khg on 2022/10/07.
//

import SwiftUI
import UIKit
import ActivityKit
import Combine

struct islandTest: View {
    
    @State private var time = Date()
    
    var body: some View {
        VStack {
            
            HStack {
                Button {
                    endActivity()
                } label: {
                    Text("중단")
                }
                
                Button {
                    startActivity()
                    
                } label: {
                    Text("시작")
                        .foregroundColor(.green)
                }
                
                Button {
                    alertNotification()
                } label: {
                    Text("테스트")
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
    }
    
    func startActivity() {
        let contentState = Attributes.ContentState(mainText: "시작", timer: Date.now...Date().addingTimeInterval(100))
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
        let update = Attributes.ContentState(mainText: "새로고침", timer: Date.now...Date().addingTimeInterval(100))
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
        let end = Attributes.ContentState(mainText: "끝", timer: Date.now...Date())
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


