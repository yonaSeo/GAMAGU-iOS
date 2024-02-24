//
//  HapticManager.swift
//  Gamagu
//
//  Created by yona on 2/17/24.
//

import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    // warning, error, success
    func hapticNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    // heavy, light, meduium, rigid, soft
    func hapticImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    func selectionChanged() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
