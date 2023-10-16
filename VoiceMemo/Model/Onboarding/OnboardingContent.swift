//
//  OnboardingContent.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/16.
//

import Foundation

struct OnboardingContent: Hashable {
    var title: String
    var subTitle: String
    var imageFileName: String
    
    init(
        title: String,
        subTitle: String,
        imageFileName: String
    ) {
        self.title = title
        self.subTitle = subTitle
        self.imageFileName = imageFileName
    }
}

let onboardingContents: [OnboardingContent] = [
    .init(title: "오늘의 할일",
          subTitle: "To do list로 언제 어디서든 해야할일을 한눈에",
          imageFileName: "onboarding_1"),
    .init(title: "똑똑한 나만의 기록장",
          subTitle: "메모장으로 생각나는 기록은 언제든지",
          imageFileName: "onboarding_2"),
    .init(title: "하나라도 놓치지 않도록",
          subTitle: "음성메모 기능으로 놓치고 싶지않은 기록까지",
          imageFileName: "onboarding_3"),
    .init(title: "정확한 시간의 경과",
          subTitle: "타이머 기능으로 원하는 시간을 확인",
          imageFileName: "onboarding_4")
]
