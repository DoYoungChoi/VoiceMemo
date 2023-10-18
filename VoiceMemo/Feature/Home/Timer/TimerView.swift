//
//  TimerView.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/17.
//

import SwiftUI

struct TimerView: View {
    @StateObject var timerViewModel = TimerViewModel()
    
    var body: some View {
        if timerViewModel.isDisplaySetTimeView {
            SetTimerView(timerViewModel: timerViewModel)
        } else {
            OperateTimerView(timerViewModel: timerViewModel)
        }
    }
}

// MARK: - 타이머 설정 뷰
private struct SetTimerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            TitleView()
            
            Spacer()
                .frame(height: 50)
            
            TimePickerView(timerViewModel: timerViewModel)
            
            Spacer()
                .frame(height: 30)
            
            TimerCreateButtonView(timerViewModel: timerViewModel)
            
            Spacer()
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("타이머")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.customBlack)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - 타이머 피커 뷰
private struct TimePickerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            
            HStack(alignment: .center) {
                Picker("Hour", selection: $timerViewModel.time.hours) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)시")
                    }
                }
                
                Text(":")
                
                Picker("Minute", selection: $timerViewModel.time.minutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)분")
                    }
                }
                
                Text(":")
                
                Picker("Second", selection: $timerViewModel.time.seconds) {
                    ForEach(0..<60) { second in
                        Text("\(second)초")
                    }
                }
            }
            .foregroundColor(.customIconGray)
            .labelsHidden()
            .pickerStyle(.wheel)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - 타이머 생성 버튼 뷰
private struct TimerCreateButtonView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        Button {
            timerViewModel.settingButtonTapped()
        } label: {
            Text("설정하기")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.customGreen)
        }
    }
}

// MARK: - 타이머 작동 뷰
private struct OperateTimerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.customOrange, lineWidth: 6)
                    .frame(width: 350)
                
                VStack {
                    Text("\(timerViewModel.timeRemaining.formattedTimeString)")
                        .font(.system(size: 38))
                        .foregroundColor(.customIconGray)
                        .monospaced()
                    
                    HStack(alignment: .bottom) {
                        Image(systemName: "bell.fill")
                        
                        Text("\(timerViewModel.time.totalSeconds.formattedSettingTime)")
                            .font(.system(size: 16))
                            .padding(.top, 10)
                    }
                    .foregroundColor(.customIconGray)
                }
            }
            
            Spacer()
                .frame(height: 10)
            
            HStack {
                Button {
                    timerViewModel.cancelButtonTapped()
                } label: {
                    Text("취소")
                        .font(.system(size: 14))
                        .foregroundColor(.customIconGray)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 22)
                        .background(
                            Circle()
                                .fill(Color.customGray2.opacity(0.3))
                        )
                }
                
                Spacer()
                
                Button {
                    timerViewModel.pauseOrResumeButtonTapped()
                } label: {
                    Text(timerViewModel.isPaused ? "계속 진행" : "일시 정지")
                        .font(.system(size: 14))
                        .foregroundColor(.customIconGray)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 7)
                        .background(
                            Circle()
                                .fill(Color(red: 1, green: 0.75, blue: 0.52, opacity: 0.3))
                        )
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
