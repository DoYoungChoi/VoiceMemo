//
//  TimerViewModel.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/17.
//

import Foundation
import UIKit

class TimerViewModel: ObservableObject {
    @Published var isDisplaySetTimeView: Bool
    @Published var time: Time
    @Published var timer: Timer?
    @Published var timeRemaining: Int
    @Published var isPaused: Bool
    var notificationService: NotificationService
    
    init(
        isDisplaySetTimeView: Bool = true,
        time: Time = .init(hours: 0, minutes: 0, seconds: 0),
        timer: Timer? = nil,
        timeRemaining: Int = 0,
        isPaused: Bool = false,
        notificationService: NotificationService = .init()
    ) {
        self.isDisplaySetTimeView = isDisplaySetTimeView
        self.time = time
        self.timer = timer
        self.timeRemaining = timeRemaining
        self.isPaused = isPaused
        self.notificationService = notificationService
    }
}

extension TimerViewModel {
    func settingButtonTapped() {
        isDisplaySetTimeView = false
        timeRemaining = time.totalSeconds
        startTimer()
    }
    
    func cancelButtonTapped() {
        stopTimer()
        isDisplaySetTimeView = true
    }
    
    func pauseOrResumeButtonTapped() {
        if isPaused {
            startTimer()
        } else {
            timer?.invalidate()
            timer = nil
        }
        
        isPaused.toggle()
    }
}

private extension TimerViewModel {
    func startTimer() {
        guard timer == nil else { return }
        
        /*
         * 앱이 background에 있는 경우에도
         * 타이머가 동작하고 알림이 오도록 해야 하기 때문에
         * 타이머를 시작하기 전 background task 등록해야 함
         */
        
        // A unique token that identifies a request to run in the background
        var backgroundTaskID: UIBackgroundTaskIdentifier?
        // Marks the start of a task that should continue if the app enters the background.
        // ==> beginBackgroundTask는 앱이 suspend되기 전에 호출하는 것이 아닌, 안정적인 상태에서 호출해야 함
        // ==> This method requests additional background execution time for your app.
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            // A handler to be called shortly before the app’s remaining background time reaches 0
            if let id = backgroundTaskID {
                // You must call this method to end a task that was started using the beginBackgroundTask
                UIApplication.shared.endBackgroundTask(id)
                backgroundTaskID = .invalid
            }
        }
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                self.notificationService.sendNotification()
                
                if let id = backgroundTaskID {
                    UIApplication.shared.endBackgroundTask(id)
                    backgroundTaskID = .invalid
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
