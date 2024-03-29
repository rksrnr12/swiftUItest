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
    var window: UIWindow?
    
    func sceneWillResignActive(_ scene: UIScene) {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized{
                let localNoti = UNMutableNotificationContent()
                localNoti.title = "알림"
//                localNoti.subtitle = ""
                localNoti.body = "할말없음"
                localNoti.sound = .default
                
                
                var date = DateComponents()
                date.hour = 23
                date.minute = 30
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: "addDayOff", content: localNoti, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
//    func sceneDidBecomeActive(_ scene: UIScene) {
//        print("becomeActive")
//    }
}
