//
//  PairButtonView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 02/03/23.
//

import SwiftUI

struct ScanPairButtonView: View {
    @StateObject private var dexDeviceVM = DexAdapterViewModel(container: .container())
    var body: some View {
        
        ZStack(alignment: .bottom) {
            ZStack {
                Button(action: {
                    if(dexDeviceVM.pin == ""){
                        dexDeviceVM.connectNFC()
                    }else{
                        dexDeviceVM.connectDexAdapter()
                    }
                }) {
                    Text(dexDeviceVM.pin == "" ? PMAConstants.Titles.pair: PMAConstants.Titles.pair)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(Font.PMA.regular(size: .seventeen))
                        .padding()
                        .foregroundColor(PMAColor.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(PMAColor.white, lineWidth: 2)
                        )
                }
                .background(PMAColor.ctablue)
                .cornerRadius(10)
            }
            .padding(10)
            .background(PMAColor.white)


        }
    }
}

struct BlueButtonViewButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ScanPairButtonView()
    }
}

