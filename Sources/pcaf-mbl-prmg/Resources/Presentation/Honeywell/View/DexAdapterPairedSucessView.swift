//
//  DexAdapterPairedSucessView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 27/02/23.
//

import SwiftUI

struct DexAdapterPairedSucessView: View {
    @Binding var showAlert: Bool
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(PMAColor.white).shadow(color: PMAColor.blackWithOpacityPointTwo, radius: 2, x: 0, y: 2)
                
            VStack(alignment: .center) {
                Image(systemName: PMAConstants.ImageName.checkmarkCircle)
                  .resizable()
                  .frame(width: 22, height: 22)
                  .foregroundColor(PMAColor.greenBackground)
                  .padding(10)
                Text(PMAConstants.Titles.dexPairedSuccessfully)
                    .font(Font.PMA.regular(size: .thirteen))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

            }.padding(15)
             .multilineTextAlignment(.leading)
            
        }.padding(.init(top: 0, leading: 15, bottom: 5 , trailing: 15))
         .frame(width: 200,height: 144)
    }
}

struct DexAdapterPairedSucessView_Previews: PreviewProvider {
    static var previews: some View {
        DexAdapterPairedSucessView(showAlert: .constant(false))
    }
}
