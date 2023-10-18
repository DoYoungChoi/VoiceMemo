//
//  VoiceRecorderView.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/17.
//

import SwiftUI

struct VoiceRecorderView: View {
    @StateObject private var voiceRecorderViewModel = VoiceRecorderViewModel()
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            VStack {
                TitleView()
                
                if voiceRecorderViewModel.recordFiles.isEmpty {
                    AnnouncementView()
                } else {
                    VoiceRecorderListView(voiceRecorderViewModel: voiceRecorderViewModel)
                        .padding(.top, 15)
                }
            }
            
            RecordButtonView(voiceRecorderViewModel: voiceRecorderViewModel)
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "선택된 음성 메모를 삭제하시겠습니까?",
            isPresented: $voiceRecorderViewModel.isDisplayRemoveVoiceRecordAlert
        ) {
            Button("삭제", role: .destructive) {
                voiceRecorderViewModel.removeSelectedVoiceRecord()
            }
            Button("취소", role: .cancel) { }
        }
        .alert(
            voiceRecorderViewModel.alertMessage ?? "알 수 없는 오류가 발생했습니다.",
            isPresented: $voiceRecorderViewModel.isDisplayAlert
        ) {
            Button("확인", role: .cancel) { }
        }
        .onChange(of: voiceRecorderViewModel.recordFiles) { recordFiles in
            homeViewModel.setVoiceRecordsCount(recordFiles.count)
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("음성메모")
                .font(.system(size: 30, weight: .bold))
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - 음성 메모 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            
            Spacer()
                .frame(height: 180)
            
            Image(systemName: "speaker.wave.2")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(.bottom, 20)
            
            Text("현재 등록된 음성메모가 없습니다.")
            
            Spacer()
                .frame(height: 5)
            
            Text("하단의 녹음 버튼을 눌러 음성 메모를 시작해주세요.")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

// MARK: - 음성 메모 리스트 뷰
private struct VoiceRecorderListView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    
    fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.vertical) {
            VStack {
                Rectangle()
                    .fill(Color.customGray0)
                    .frame(height: 1)
                
                ForEach(voiceRecorderViewModel.recordFiles, id:\.self) { recordFile in
                    // 음성 메모 셀 뷰
                    VoiceRecorderCellView(
                        voiceRecorderViewModel: voiceRecorderViewModel,
                        recordFile: recordFile
                    )
                }
            }
        }
    }
}

// MARK: - 음성 메모 셀 뷰
private struct VoiceRecorderCellView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    private var recordFile: URL
    private var creationDate: Date?
    private var duration: TimeInterval?
    private var progressBarValue: Float {
        if voiceRecorderViewModel.selectedRecordFile == recordFile
            && (voiceRecorderViewModel.isPlaying || voiceRecorderViewModel.isPaused) {
            return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }
    
    fileprivate init(
        voiceRecorderViewModel: VoiceRecorderViewModel,
        recordFile: URL
    ) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.recordFile = recordFile
        (self.creationDate, self.duration) = voiceRecorderViewModel.getFileInfo(for: recordFile)
    }
    
    fileprivate var body: some View {
        VStack {
            Button {
                voiceRecorderViewModel.voiceRecordCellTapped(recordFile)
            } label: {
                VStack {
                    HStack {
                        Text(recordFile.lastPathComponent)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.customBlack)
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        if let creationDate = creationDate {
                            Text(creationDate.formattedVoiceRecoderDate)
                                .font(.system(size: 14))
                        }
                        
                        Spacer()
                        
                        if voiceRecorderViewModel.selectedRecordFile != recordFile,
                           let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 14))
                        }
                    }
                    .foregroundColor(.customIconGray)
                }
            }
            .padding(.horizontal, 20)
            
            if voiceRecorderViewModel.selectedRecordFile == recordFile {
                VStack {
                    // 프로그래스 바
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Text(voiceRecorderViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 10, weight: .medium))
                        
                        Spacer()
                        
                        if let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 10, weight: .medium))
                        }
                    }
                    .foregroundColor(.customIconGray)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if voiceRecorderViewModel.isPaused {
                                voiceRecorderViewModel.resumePlaying()
                            } else {
                                voiceRecorderViewModel.startPlaying(recordingURL: recordFile)
                            }
                        } label: {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.customBlack)
                        }
                        
                        Spacer()
                            .frame(width: 30)
                        
                        Button {
                            if voiceRecorderViewModel.isPlaying {
                                voiceRecorderViewModel.pausePlaying()
                            }
                        } label: {
                            Image(systemName: "pause.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.customBlack)
                        }
                        
                        Spacer()
                        
                        Button {
                            voiceRecorderViewModel.removeButtonTapped()
                        } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.customBlack)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - 프로그레스 바
private struct ProgressBar: View {
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.customGray2)
                
                Rectangle()
                    .fill(Color.customGreen)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
            }
        }
    }
}

// MARK: - 녹음 버튼 뷰
private struct RecordButtonView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    
    fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    voiceRecorderViewModel.recordButtonTapped()
                } label: {
                    if voiceRecorderViewModel.isRecording {
                        Image("mic_recording")
                    } else {
                        Image("mic")
                    }
                }
            }
        }
    }
}

struct VoiceRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceRecorderView()
            .environmentObject(HomeViewModel())
    }
}
