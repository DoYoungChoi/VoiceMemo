//
//  WriteButton.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/18.
//

import SwiftUI

// 디자인 시스템의 경우에는 별도 모듈로 분리하는 경우가 많기 때문에 public으로 만드는 것을 권장함

// MARK: - 1️⃣
public struct WriteButtonViewModifier: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: action) {
                        Circle()
                            .fill(Color.customGreen)
                            .frame(width: 50)
                            .overlay {
                                Image("pencil")
                                    .renderingMode(.template)
                                    .foregroundColor(.customWhite)
                            }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

// MARK: - 2️⃣
extension View {
    public func writeButton(perform action: @escaping () -> Void) -> some View {
        ZStack {
            self
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: action) {
                        Circle()
                            .fill(Color.customGreen)
                            .frame(width: 50)
                            .overlay {
                                Image("pencil")
                                    .renderingMode(.template)
                                    .foregroundColor(.customWhite)
                            }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

// MARK: - 3️⃣
public struct WriteButtonView<Content: View>: View {
    let content: Content
    let action: () -> Void
    
    public init(
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) {
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: action) {
                        Circle()
                            .fill(Color.customGreen)
                            .frame(width: 50)
                            .overlay {
                                Image("pencil")
                                    .renderingMode(.template)
                                    .foregroundColor(.customWhite)
                            }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}
