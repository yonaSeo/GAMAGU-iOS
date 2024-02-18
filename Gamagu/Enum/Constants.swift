//
//  Constants.swift
//  Gamagu
//
//  Created by yona on 2/12/24.
//

import UIKit

enum AlarmContentType: String, CaseIterable {
    case titleAndContent = "제목 + 내용"
    case categoryAndContent = "카테고리 + 내용"
    case categoryAndTitle = "카테고리 + 제목"
    case titleOnly = "제목만"
    case contentOnly = "내용만"
}

enum AlarmSoundType: String, CaseIterable {
    case crowA = "까악"
    case crowB = "까악x2"
    case crowC = "까악x3"
    case kyak = "꺅"
    case byak = "뺙"
    case basic = "기본음"
    
    var caseName: String {
        return AlarmSoundType.makeSoundName(type: self.rawValue)
    }
    
    static func makeSoundName(type: String) -> String {
        switch type {
        case self.crowA.rawValue: return "crowA"
        case self.crowB.rawValue: return "crowB"
        case self.crowC.rawValue: return "crowC"
        case self.kyak.rawValue: return "kyak"
        case self.byak.rawValue: return "byak"
        default: return ""
        }
    }
}

enum CategoryAlarmCycle: String, CaseIterable {
    case oneDay = "하루"
    case oneWeek = "일주일"
    case oneMonth = "한 달"
}
