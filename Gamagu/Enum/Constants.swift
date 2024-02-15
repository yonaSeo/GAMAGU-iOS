//
//  Constants.swift
//  Gamagu
//
//  Created by yona on 2/12/24.
//

import UIKit

enum AlarmContentType: String, CaseIterable {
    case titleAndContent = "제목 + 내용"
    case categoryAndTitle = "카테고리 + 제목"
    case categoryAndContent = "카테고리 + 내용"
    case titleOnly = "제목만"
    case contentOnly = "내용만"
}

enum AlarmSoundType: String, CaseIterable {
    case crowA = "까마귀 울음소리 A"
    case crowB = "까마귀 울음소리 B"
    case crowC = "까마귀 울음소리 C"
}

enum CategoryAlarmCycle: String, CaseIterable {
    case oneDay = "하루"
    case oneWeek = "일주일"
    case oneMonth = "한 달"
}
