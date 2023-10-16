//
//  MemoListView.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/16.
//

import SwiftUI

struct MemoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if !memoListViewModel.memos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftButton: false,
                        rightButtonAction: memoListViewModel.navigationRightButtonTapped,
                        rightButtonType: memoListViewModel.navigationBarRightButtonMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
                
                TitleView()
                
                if memoListViewModel.memos.isEmpty {
                    AnnouncementView()
                } else {
                    MemoListContentView()
                        .padding(.top, 20)
                }
            }
            
            WriteMemoButtonView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "메모 \(memoListViewModel.removeMemoCount)개 삭제하시겠습니까?",
            isPresented: $memoListViewModel.isDisplayRemoveMemoAlert
        ) {
            Button("삭제", role: .destructive) {
                memoListViewModel.removeButtonTapped()
            }
            Button("취소", role: .cancel) { }
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if memoListViewModel.memos.isEmpty {
                Text("메모를\n추가해 보세요.")
            } else {
                Text("메모 \(memoListViewModel.memos.count)개가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template)
            
            VStack(spacing: 5) {
                Text("\"퇴근 9시간 전 메모\"")
                Text("\"개발 끝낸 후 퇴근하기!\"")
                Text("\"밀린 집안일 하기 메모\"")
            }
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

// MARK: - 메모 리스트 컨텐츠 뷰
private struct MemoListContentView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("메모 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(memoListViewModel.memos, id:\.self) { memo in
                        MemoCellView(memo: memo)
                    }
                }
            }
        }
    }
}

private struct MemoCellView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @State private var isRemoveSelected: Bool
    private var memo: Memo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        memo: Memo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.memo = memo
    }
    
    fileprivate var body: some View {
        Button {
            pathModel.paths.append(.memoView(isCreatMode: false, memo: memo))
        } label: {
            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(memo.title)
                            .lineLimit(1)
                            .font(.system(size: 16))
                            .foregroundColor(.customBlack)
                        
                        Text(memo.convertedDate)
                            .font(.system(size: 12))
                            .foregroundColor(.customIconGray)
                    }
                    
                    Spacer()
                    
                    if memoListViewModel.isEditMemoMode {
                        Button {
                            isRemoveSelected.toggle()
                            memoListViewModel.memoRemoveSelectedBoxTapped(memo)
                        } label: {
                            Image(systemName: isRemoveSelected ? "trash.square.fill" : "square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.customGreen)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                Rectangle()
                    .fill(Color.customGray0)
                    .frame(height: 1)
            }
        }
    }
}

// MARK: - 메모 작성 버튼 뷰
private struct WriteMemoButtonView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    // TODO: - 메모 뷰 구현 후 돌아와서 구현 필요
                    pathModel.paths.append(.memoView(isCreatMode: true, memo: nil))
                } label: {
                    Circle()
                        .fill(Color.customGreen)
                        .frame(width: 50, height: 50)
                        .overlay {
                            Image("pencil")
                                .renderingMode(.template)
                                .foregroundColor(.customWhite)
                        }
                }
            }
        }
    }
}

struct MemoListView_Previews: PreviewProvider {
    static var previews: some View {
        MemoListView()
            .environmentObject(PathModel())
            .environmentObject(MemoListViewModel())
    }
}
