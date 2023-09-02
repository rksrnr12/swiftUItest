//
//  NotificationController.swift
//  WatchTest0708 Watch App
//
//  Created by khg on 2023/05/03.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationController:WKUserNotificationHostingController<NotificationView> {
    
    override var body: NotificationView {
        return NotificationView()
    }
    
    override func willActivate() {
        //워치 뷰 컨트롤러가 사용자에게 보이려고 할 때
        super.willActivate()
    }
    
    override func didDeactivate() {
        //워치 뷰 컨트롤러가 더이상 보이지 않을 때
        super.didDeactivate()
    }
    
    override func didReceive(_ notification: UNNotification) {
        print(notification.request.content.title)
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
    }
}
