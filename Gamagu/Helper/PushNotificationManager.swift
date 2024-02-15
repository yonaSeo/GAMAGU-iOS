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
    
    func setPushNotification(category: Category, identifier: String) {
        var contents = [UNMutableNotificationContent]()
        
        CoreDataManager.shared.fetchData()
        let userSetting = CoreDataManager.shared.getUserSetting()
        let items = CoreDataManager.shared.getItemsOfCategory(category: category)
        
        items.forEach { item in
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = item.title ?? ""
            notificationContent.body = item.content ?? ""
            notificationContent.sound = userSetting.isAlarmSoundActive ? .default : nil
            contents.append(notificationContent)
        }
        
        let startTimeComponent = Calendar.current.dateComponents([.hour, .minute], from: userSetting.alarmStartTime!)
        let endTimeComponent = Calendar.current.dateComponents([.hour, .minute], from: userSetting.alarmEndTime!)
        
        if category.alarmCycleDayCount == 1 {
            contents.forEach { content in
                let randomOneDayDateComponentsArray = generateOneDayRandomDateComponentsArray(
                    startHour: startTimeComponent.hour!,
                    startMinute: startTimeComponent.minute!,
                    endHour: endTimeComponent.hour!,
                    endMinute: endTimeComponent.minute!,
                    count: contents.count
                )
                print(randomOneDayDateComponentsArray)
                
                randomOneDayDateComponentsArray.forEach { dateComponents in
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error { print("Error: \(error.localizedDescription)")}
                    }
                }
            }
        } else {
            contents.forEach { content in
                let randomLonggerDateComponentsArray = generateLonggerRandomDateComponentsArray(
                    startHour: startTimeComponent.hour!,
                    startMinute: startTimeComponent.minute!,
                    endHour: endTimeComponent.hour!,
                    endMinute: endTimeComponent.minute!,
                    count: contents.count, 
                    cycle: Int(category.alarmCycleDayCount)
                )
                print(randomLonggerDateComponentsArray)
                
                randomLonggerDateComponentsArray.forEach { dateComponents in
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error { print("Error: \(error.localizedDescription)")}
                    }
                }
            }
        }
    }
    
    func generateOneDayRandomDateComponentsArray(startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, count: Int) -> [DateComponents] {
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

    func generateLonggerRandomDateComponentsArray(startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, count: Int, cycle: Int) -> [DateComponents] {
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
        let randomInterval = Int.random(in: 1...10) // 최소 1시간 이상 간격
        randomHour += randomInterval
        
        // 종료 시간 이후로 넘어가지 않도록 제한
        while randomHour > endHour || randomHour < startHour {
            randomHour = randomHour % endHour + startHour - 1
        }
        
        // 분은 0부터 59까지 랜덤으로 선택
        if randomHour == startHour { randomMinute = Int.random(in: startMinute...59) }
        else if randomHour == endHour { randomMinute = Int.random(in: 0...endMinute) }
        else { randomMinute = Int.random(in: 0...59) }
        
        return (hour: randomHour, minute: randomMinute)
    }
}
