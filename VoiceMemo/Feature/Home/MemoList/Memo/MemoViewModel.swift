//
//  MemoViewModel.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/16.
//

import Foundation

class MemoViewModel: ObservableObject {
    @Published var memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
    }
}
