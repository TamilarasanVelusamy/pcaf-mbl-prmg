//
//  FirmwareUpdatedSuccessfullyView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 12/29/22.
//

import SwiftUI

struct FirmwareUpdatedSuccessfullyMsgView: View {
    
    var firmwareVersion : String
    var newFirmware : String

    var body: some View {
        
        HStack {
            Image( systemName: PMAConstants.ImageName.checkmarkCircle)
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(PMAColor.greenBackground)
                .padding(.init(top: 10, leading: 5, bottom: 0 , trailing: 0))
            Text(newFirmware < firmwareVersion ? PMAConstants.Titles.downgradeSuccessfully :  PMAConstants.Titles.updateSuccessfully)
                .font(Font.PMA.bold(size: .seventeen))
                .foregroundColor(PMAColor.greenBackground)
                .padding(.init(top: 10, leading: 5, bottom: 0 , trailing: 0))
        }

    }
}

struct FirmwareUpdatedSuccessfullyMsgView_Previews: PreviewProvider {
    static var previews: some View {
        FirmwareUpdatedSuccessfullyMsgView(firmwareVersion: "0137", newFirmware: "0134")
    }
}
