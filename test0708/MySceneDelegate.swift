//
//  MySceneDelegate.swift
//  test0708
//
//  Created by khg on 2022/09/14.
//

import Foundation
import UIKit
import SwiftUI

class MySceneDelegate: NSObject, UIWindowSceneDelegate {
    @AppStorage("myDayOff") var myDayOff = 0.0
    var window: UIWindow?
    
    
    
    func sceneWillResignActive(_ scene: UIScene) {
        
        UNUserNotificationCenter.current().getNotificationSettings { [self] settings in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized{
                let localNoti = UNMutableNotificationContent()
                localNoti.title = "연차 추가"
                localNoti.subtitle = "클릭 시 연차가 1일 추가됨"
                localNoti.body = "현재 연차 = \(myDayOff)"
                
                
                var date = DateComponents()
                date.day = 17
                date.hour = 10
                date.minute = 00
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
                let request = UNNotificationRequest(identifier: "addDayOff", content: localNoti, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}
