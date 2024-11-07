//
//  BottomDexInfoView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 02/03/23.
//

import SwiftUI

struct BottomDexInfoView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Text(PMAConstants.Titles.pairingInfo)
                .font(Font.PMA.regular(size: .thirteen))
                .foregroundColor(PMAColor.gray)
        }
    }
}

struct BottomDexInfoView_Previews: PreviewProvider {
    static var previews: some View {
        BottomDexInfoView()
    }
}
