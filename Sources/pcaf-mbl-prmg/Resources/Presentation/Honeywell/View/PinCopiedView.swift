//
//  PinCopiedView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 27/02/23.
//

import SwiftUI

struct PinCopiedView: View {

    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(PMAColor.greenWithPointTwo).shadow(color: PMAColor.blackWithOpacityPointTwo, radius: 2, x: 0, y: 2)
                .frame(width: 104, height: 32)
            VStack{
                Text(PMAConstants.Titles.pinCopied)
                    .frame(width: 104, height: 32)
                    .foregroundColor(PMAColor.green)
            }
        }
    }
}

struct PinCopiedView_Previews: PreviewProvider {
    static var previews: some View {
        PinCopiedView()
    }
}
