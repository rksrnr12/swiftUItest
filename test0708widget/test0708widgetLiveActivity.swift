//
//  test0708widgetLiveActivity.swift
//  test0708widget
//
//  Created by khg on 2022/10/07.
//

import ActivityKit
import WidgetKit
import SwiftUI

//struct test0708widgetAttributes: ActivityAttributes {
//    public struct ContentState: Codable, Hashable {
//        // Dynamic stateful properties about your activity go here!
//        var value: Int
//    }
//
//    // Fixed non-changing properties about your activity go here!
//    var name: String
//}

struct test0708widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Attributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text(context.attributes.total)
                Text(String(context.attributes.number))
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                     Text("😃")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.green)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("아래")
                    // more content
                }
            }
             compactLeading: {
                Text(context.state.testname)
            } compactTrailing: {
                Text(String(context.state.testnum))
            } minimal: {
                Text(context.state.testname)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
            .contentMargins(.all, 30, for: .expanded)
        }
    }
}
