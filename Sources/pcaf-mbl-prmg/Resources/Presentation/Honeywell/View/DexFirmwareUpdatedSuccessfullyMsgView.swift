//
//  DexFirmwareUpdatedSuccessfullyMsgView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 07/03/23.
//

import SwiftUI

struct DexFirmwareUpdatedSuccessfullyMsgView: View {
    var firmwareVersion : String
    var newFirmware : String
    var body: some View {
        
        HStack {
            Image( systemName: PMAConstants.ImageName.checkmarkCircle)
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(PMAColor.greenBackground)
                .padding(.init(top: 10, leading: 5, bottom: 0 , trailing: 0))
            Text(newFirmware < firmwareVersion ? PMAConstants.Titles.downgradeSuccessfully : PMAConstants.Titles.updateSuccessfully)
                .font(Font.PMA.bold(size: .seventeen))
                .foregroundColor(PMAColor.greenBackground)
                .padding(.init(top: 10, leading: 5, bottom: 0 , trailing: 0))
        }.onAppear() {
             let successAlert = UserDefaults.standard.bool(forKey: PMAConstants.UserDefaultskey.successFirmwareAlert)
                if successAlert {
                    return
                }
            NotificationCenter.default.post(name: NSNotification.dexDeviceFWUpgradeSuccessAlert, object: nil, userInfo: nil)
        }
        
        
    }
}

struct DexFirmwareUpdatedSuccessfullyMsgView_Previews: PreviewProvider {
    static var previews: some View {
        DexFirmwareUpdatedSuccessfullyMsgView(firmwareVersion: "123", newFirmware: "134")
    }
}
