//
//  HapticTest.swift
//  test0708
//
//  Created by khg on 2022/08/25.
//

import SwiftUI

struct HapticTest: View {
    var body: some View {
        VStack(spacing:20){
            Text("warning")
                .onLongPressGesture {
                    HapticManager.manager.notification(type: .warning)
                }
            Text("error")
                .onLongPressGesture {
                    HapticManager.manager.notification(type: .error)
                }
            Text("succes")
                .onLongPressGesture {
                    HapticManager.manager.notification(type: .success)
                }
            Text("heavy")
                .onLongPressGesture {
                    HapticManager.manager.impact(style: .heavy)
                }
            Text("light")
                .onLongPressGesture {
                    HapticManager.manager.impact(style: .light)
                }
            Text("medium")
                .onLongPressGesture {
                    HapticManager.manager.impact(style: .medium)
                }
            Text("rigid")
                .onLongPressGesture {
                    HapticManager.manager.impact(style: .rigid)
                }
            Text("soft")
                .onLongPressGesture {
                    HapticManager.manager.impact(style: .soft)
                }
        }
    }
}


