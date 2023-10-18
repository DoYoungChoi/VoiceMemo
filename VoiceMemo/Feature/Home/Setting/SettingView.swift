//
//  SettingView.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/18.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack {
            TitleView()
            
            Spacer()
                .frame(height: 35)
            
            TotalTabCountView()
            
            Spacer()
                .frame(height: 35)
            
            TotalTabMoveView()
            
            Spacer()
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("설정")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.customBlack)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 45)
    }
}

// MARK: - 전체 탭 설정된 카운트 뷰
private struct TotalTabCountView: View {
    fileprivate var body: some View {
        // TODO: - 개수
        HStack {
            Spacer()
            TabCountView(title: "To do", count: 0)
            Spacer()
                .frame(width: 80)
            TabCountView(title: "메모", count: 10)
            Spacer()
                .frame(width: 80)
            TabCountView(title: "음성메모", count: 0)
            Spacer()
        }
    }
}

// MARK: - 각 탭 설정된 카운트 뷰 (공통 뷰 컴포넌트)
private struct TabCountView: View {
    private var title: String
    private var count: Int
    
    fileprivate init(title: String, count: Int) {
        self.title = title
        self.count = count
    }
    
    fileprivate var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.customBlack)
            
            Text("\(count)")
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(.customBlack)
        }
    }
}

// MARK: - 전체 탭 이동 뷰
private struct TotalTabMoveView: View {
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            
            // TODO: - 탭 액션
            TabMoveView(title: "To do 리스트", tabAction: { })
            TabMoveView(title: "메모", tabAction: { })
            TabMoveView(title: "음성메모", tabAction: { })
            TabMoveView(title: "타이머", tabAction: { })
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - 각 탭 이동 뷰
private struct TabMoveView: View {
    private var title: String
    private var tabAction: () -> Void
    
    fileprivate init(
        title: String,
        tabAction: @escaping () -> Void
    ) {
        self.title = title
        self.tabAction = tabAction
    }
    
    fileprivate var body: some View {
        Button(action: tabAction) {
            HStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.customBlack)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.customGray1)
            }
        }
        .padding(20)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
