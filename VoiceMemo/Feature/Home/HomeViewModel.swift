//
//  HomeViewModel.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/18.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedTab: Tab
    @Published var todosCount: Int
    @Published var memosCount: Int
    @Published var voiceRecordCount: Int
    
    init(
        selectedTab: Tab = .voiceRecorder,
        todosCount: Int = 0,
        memosCount: Int = 0,
        voiceRecordCount: Int = 0
    ) {
        self.selectedTab = selectedTab
        self.todosCount = todosCount
        self.memosCount = memosCount
        self.voiceRecordCount = voiceRecordCount
    }
}

extension HomeViewModel {
    func setTodosCount(_ count: Int) {
        todosCount = count
    }
    
    func setMemosCount(_ count: Int) {
        memosCount = count
    }
    
    func setVoiceRecordsCount(_ count: Int) {
        voiceRecordCount = count
    }
    
    // Tab 변경 메서드
    func changeSelectedTab(_ tab: Tab) {
        selectedTab = tab
    }
}
