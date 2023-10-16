//
//  PathType.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/16.
//

import Foundation

enum PathType: Hashable {
    case homeView
    case todoView
    case memoView(isCreatMode: Bool, memo: Memo?)
}
