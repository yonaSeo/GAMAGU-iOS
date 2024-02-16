//
//  PushNotificationManager.swift
//  Gamagu
//
//  Created by yona on 2/14/24.
//

import UIKit

final class PushNotificationManager {
    static let shared = PushNotificationManager()
    private init() {}
    
    func setAutorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: options, completionHandler: { _, _ in }
        )
    }
    
    func refreshAllPushNotifications() {
        let categories = CoreDataManager.shared.getCategoriesWithoutNoItem()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // print("🚨 All Deleted")
        categories.forEach { setPushNotificationsOfCategory(category: $0) }
    }
    
    func refreshPushNotificationsOfCategory(category: Category) {
        removePushNotificationsOfCategory(category: category)
        setPushNotificationsOfCategory(category: category)
    }
    
    func removePushNotificationOfItem(itemTitle: String, category: Category) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: (0..<category.alarmPushCount).map { index in
                // print("❌ \(itemTitle)_\(index)")
                return "\(itemTitle)_\(index)"
            }
        )
    }
    
    func removePushNotificationsOfCategory(category: Category) {
        let itemTitles = CoreDataManager.shared.getItemsOfCategory(category: category).map { $0.title ?? "" }
        itemTitles.forEach { itemTitle in
            UNUserNotificationCenter.current().removePendingNotificationRequests(
                withIdentifiers: (0..<category.alarmPushCount).map { index in
                    // print("❌ \(itemTitle)_\(index)")
                    return "\(itemTitle)_\(index)"
                }
            )
        }
    }
    
    func setPushNotificationsOfCategory(category: Category) {
        var notificationContents = [UNMutableNotificationContent]()
        
        CoreDataManager.shared.fetchData()
        let userSetting = CoreDataManager.shared.getUserSetting()
        let items = CoreDataManager.shared.getItemsOfCategory(category: category)
        
        items.forEach { item in
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = item.title ?? ""
            notificationContent.body = item.content ?? ""
            notificationContent.sound = userSetting.isAlarmSoundActive ? .default : nil
            notificationContents.append(notificationContent)
        }
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        
        let startTimeComponent = calendar.dateComponents([.hour, .minute], from: userSetting.alarmStartTime!)
        let endTimeComponent = calendar.dateComponents([.hour, .minute], from: userSetting.alarmEndTime!)
        
        // print("➡️ start -> \(startTimeComponent)")
        // print("⬅️ end -> \(endTimeComponent)")
        
        if category.alarmCycleDayCount == 1 {
            notificationContents.forEach { content in
                let randomOneDayDateComponentsArray = generateOneDayRandomDateComponentsArray(
                    startHour: startTimeComponent.hour!,
                    startMinute: startTimeComponent.minute!,
                    endHour: endTimeComponent.hour!,
                    endMinute: endTimeComponent.minute!,
                    count: Int(category.alarmPushCount)
                )
                // print("alarm: \(content.title)")
                // print("times: \(randomOneDayDateComponentsArray)")
        
                // index 개수 == alarmPushCount 개수
                randomOneDayDateComponentsArray.enumerated().forEach { index, dateComponents in
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    let request = UNNotificationRequest(identifier: "\(content.title)_\(index)", content: content, trigger: trigger)
                    // print("id: \(content.title)_\(index)")
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error { print("Error: \(error.localizedDescription)")}
                    }
                }
            }
        } else {
            notificationContents.forEach { content in
                let randomLonggerDateComponentsArray = generateLonggerRandomDateComponentsArray(
                    startHour: startTimeComponent.hour!,
                    startMinute: startTimeComponent.minute!,
                    endHour: endTimeComponent.hour!,
                    endMinute: endTimeComponent.minute!,
                    count: Int(category.alarmPushCount),
                    cycle: Int(category.alarmCycleDayCount)
                )
                
                // print("alarm: \(content.title)")
                // print("times: \(randomLonggerDateComponentsArray)")
                
                randomLonggerDateComponentsArray.enumerated().forEach { index, dateComponents in
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    let request = UNNotificationRequest(identifier: "\(content.title)_\(index)", content: content, trigger: trigger)
                    // print("id: \(content.title)_\(index)")
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error { print("Error: \(error.localizedDescription)")}
                    }
                }
            }
        }
    }
    
    private func generateOneDayRandomDateComponentsArray(startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, count: Int) -> [DateComponents] {
        var randomDateComponentsArray: [DateComponents] = []
        var hour = Int.random(in: startHour...endHour)
        var minute = 0
        
        for _ in 1...count {
            (hour, minute) = makeRandomHourAndMinute(
                hour: hour, startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute
            )
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            randomDateComponentsArray.append(dateComponents)
        }
        
        
        return randomDateComponentsArray
            .sorted { $0.hour! < $1.hour! }
            .sorted { $0.hour! == $1.hour! && $0.minute! < $1.minute! }
    }

    private func generateLonggerRandomDateComponentsArray(startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, count: Int, cycle: Int) -> [DateComponents] {
        var randomDateComponentsArray: [DateComponents] = []
        var hour = Int.random(in: startHour...endHour)
        var minute = 0
        var days: [Int] = []
        var day = Int.random(in: 1...cycle)
        
        for _ in 1...count {
            (hour, minute) = makeRandomHourAndMinute(
                hour: hour, startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute
            )
            
            var dateComponents = DateComponents()
            if cycle == 7 { dateComponents.weekday = day }
            else { dateComponents.day = day }
            dateComponents.hour = hour
            dateComponents.minute = minute
            randomDateComponentsArray.append(dateComponents)
            
            days.append(day)
            day = Int.random(in: 1...cycle)
            while days.contains(where: { $0 == day }) && days.count != cycle {
                day = Int.random(in: 1...cycle)
            }
        }
        
        return cycle == 7
        ? randomDateComponentsArray
            .sorted { $0.weekday! < $1.weekday! }
            .sorted { $0.weekday! == $1.weekday! && $0.hour! < $1.hour! }
            .sorted { $0.weekday! == $1.weekday! && $0.hour! == $1.hour! && $0.minute! < $1.minute! }
        :randomDateComponentsArray
            .sorted { $0.day! < $1.day! }
            .sorted { $0.day! == $1.day! && $0.hour! < $1.hour! }
            .sorted { $0.day! == $1.day! && $0.hour! == $1.hour! && $0.minute! < $1.minute! }
    }

    func makeRandomHourAndMinute(hour: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int) -> (hour: Int, minute: Int) {
        var randomMinute = 0
        var randomHour = hour
        
        // 최소 1시간 간격 이상으로 랜덤한 시간 추출
        let randomInterval = Int.random(in: 3...6) // 최소 3시간 이상 간격
        randomHour += randomInterval
        
        // 종료 시간 이후로 넘어가지 않도록 제한
        if endHour == 0 {
            randomHour = 0
        } else {
            while randomHour > endHour || randomHour < startHour {
                randomHour = randomHour % endHour + startHour - 1
                if randomHour <= 0 { randomHour = Int.random(in: startHour...endHour) }
            }
        }
        
        // 분은 0부터 59까지 랜덤으로 선택
        if startHour == endHour { randomMinute = Int.random(in: startMinute...endMinute) }
        else if randomHour == startHour { randomMinute = Int.random(in: startMinute...59) }
        else if randomHour == endHour { randomMinute = Int.random(in: 0...endMinute) }
        else { randomMinute = Int.random(in: 0...59) }
        
        return (hour: randomHour, minute: randomMinute)
    }
}
