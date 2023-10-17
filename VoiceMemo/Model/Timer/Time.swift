//
//  Time.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/17.
//

import Foundation

struct Time {
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    var totalSeconds: Int {
        return (hours * 3600) + (minutes * 60) + seconds
    }
    
    static func fromSeconds(_ seconds: Int) -> Time {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = (seconds % 3600) % 60
        return Time(hours: hours, minutes: minutes, seconds: remainingSeconds)
    }
}
