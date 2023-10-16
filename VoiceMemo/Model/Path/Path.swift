//
//  Path.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/16.
//

import Foundation

class PathModel: ObservableObject {
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}
