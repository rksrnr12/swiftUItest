//
//  test0708widgetLiveActivity.swift
//  test0708widget
//
//  Created by khg on 2022/10/07.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct test0708widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct test0708widgetLiveActivity: Widget {
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Attributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                Text(context.state.testname)
                Spacer()
                Text(String(context.state.testnum))
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            .padding(.horizontal,20)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                //MARK: - 큰화면 왼쪽
                DynamicIslandExpandedRegion(.leading) {
                    VStack{
                        Text("😃")
                    }
                }
                //MARK: - 큰화면 오른쪽
                DynamicIslandExpandedRegion(.trailing) {
                    VStack{
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.green)
                    }
                   
                }
                //MARK: - 큰화면 아래
                DynamicIslandExpandedRegion(.bottom) {
                    VStack{
                        Text("아래")
                    }
                    // more content
                }
            }
            //MARK: - 작은 왼쪽
             compactLeading: {
                Text(context.state.testname)
            }
            //MARK: - 작은 오른쪽
            compactTrailing: {
                Text(String(context.state.testnum))
            }
            //MARK: - 2개 실행 동그라미
            minimal: {
                Text(String(context.state.testnum))
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
            .contentMargins(.all, 30, for: .expanded)
        }
    }
}
