//
//  Memo.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/16.
//

import Foundation

struct Memo: Hashable {
    var title: String
    var content: String
    var date: Date
    let id = UUID()
    
    var convertedDate: String {
        String("\(date.formattedDay) - \(date.formattedTime)")
    }
}
