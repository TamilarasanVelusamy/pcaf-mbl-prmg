//
//  FlashModeButtonView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 28/02/23.
//

import SwiftUI

struct FlashModeButtonView: View {
  
    var body: some View {
        
        Button(action: {
            NotificationCenter.default.post(name: NSNotification.enterDexFlashMode, object: nil, userInfo: nil)
        }) {
            Text(PMAConstants.Titles.dexFlashMode)
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(Font.PMA.regular(size: .seventeen))
                .padding()
                .foregroundColor(PMAColor.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(PMAColor.white, lineWidth: 2)
                )
        }
        .background(PMAColor.ctablue) // If you have this
        .cornerRadius(10)
    }
}

struct FlashModeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FlashModeButtonView()
    }
}
