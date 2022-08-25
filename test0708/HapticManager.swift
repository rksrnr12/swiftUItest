//
//  HapticManager.swift
//  test0708
//
//  Created by khg on 2022/08/25.
//

import Foundation
import UIKit

class HapticManager {
    
    static let manager = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
}
