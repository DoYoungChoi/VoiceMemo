//
//  TodoViewModel.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/16.
//

import Foundation

class TodoViewModel: ObservableObject {
    @Published var title: String
    @Published var time: Date
    @Published var day: Date
    @Published var isDisplayCalender: Bool
    
    init(
        title: String = "",
        time: Date = Date(),
        day: Date = Date(),
        isDisplayCalender: Bool = false
    ) {
        self.title = title
        self.time = time
        self.day = day
        self.isDisplayCalender = isDisplayCalender
    }
}

extension TodoViewModel {
    func setIsDisplayCalendar(_ isDisplay: Bool) {
        isDisplayCalender = isDisplay
    }
}
