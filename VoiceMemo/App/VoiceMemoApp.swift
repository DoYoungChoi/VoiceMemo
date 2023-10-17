//
//  VoiceMemoApp.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/13.
//

import SwiftUI

@main
struct VoiceMemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
