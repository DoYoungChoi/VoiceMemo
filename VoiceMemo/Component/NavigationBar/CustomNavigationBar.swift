//
//  CustomNavigationBar.swift
//  VoiceMemo
//
//  Created by dodor on 2023/10/16.
//

import SwiftUI

struct CustomNavigationBar: View {
    let isDisplayLeftButton: Bool
    let isDisplayRightButton: Bool
    let leftButtonAction: () -> Void
    let rightButtonAction: () -> Void
    let rightButtonType: NavigationBarButtonType
    
    init(
        isDisplayLeftButton: Bool = true,
        isDisplayRightButton: Bool = true,
        leftButtonAction: @escaping () -> Void = {},
        rightButtonAction: @escaping () -> Void = {},
        rightButtonType: NavigationBarButtonType = .edit
    ) {
        self.isDisplayLeftButton = isDisplayLeftButton
        self.isDisplayRightButton = isDisplayRightButton
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
        self.rightButtonType = rightButtonType
    }
    
    var body: some View {
        HStack {
            if isDisplayLeftButton {
                Button(action: leftButtonAction) {
                    Image(systemName: "arrow.left")
                }
            }
            
            Spacer()
            
            if isDisplayRightButton {
                Button(action: rightButtonAction) {
                    if rightButtonType == .close {
                        Image(systemName: "X")
                    } else {
                        Text(rightButtonType.rawValue)
                    }
                }
            }
        }
        .foregroundColor(.customBlack)
        .padding(.horizontal, 20)
        .frame(height: 20)
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar()
    }
}
