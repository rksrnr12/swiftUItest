//
//  MyAppDelegate.swift
//  test0708
//
//  Created by khg on 2022/09/14.
//

import Foundation
import FirebaseCore
import UIKit
import SwiftUI
import HealthKit
import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin

class MyAppDelegate: NSObject,UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //FirebaseApp.configure()
        do {
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify 초기화 완료")
        }catch {
            print("aws오류")
        }
        let notiCenter = UNUserNotificationCenter.current()
        notiCenter.requestAuthorization(options: [.alert,.sound,.badge]) { didAllow, error in }
        notiCenter.delegate = self
        
        let healthData = HKHealthStore()
        let requestData = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!,HKObjectType.quantityType(forIdentifier: .stepCount)!,HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,HKObjectType.quantityType(forIdentifier: .distanceCycling)!])
        
        healthData.requestAuthorization(toShare: requestData, read: requestData) { success, error in }
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        //앱 켜져 있을때
        print("나옴")
        NotificationCenter.default.post(name: .init("alert"), object: nil)
        return [.list,.banner,.sound,.badge]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        //알림창 누르면 실행
        print("실행")
        center.setBadgeCount(0) { _ in }
    }
        
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
//        print("받음")
//
//        return .noData
//    }
    
    
    
  
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = MySceneDelegate.self
        return sceneConfig
    }
}
