//
//  FirmwareUpdatedSuccessfullyView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 12/29/22.
//

import SwiftUI

struct FirmwareUpdatedSuccessfullyView: View {
    
    var firmwareVersion : String
    var newFirmware : String
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text(PMAConstants.Titles.firmwareUptoDate)
                    .font(Font.PMA.bold(size: .fifteen))
                    .foregroundColor(.primary).padding(1)
                Text("\(PMAConstants.Titles.currentFirmware) \(firmwareVersion)")
                    .font(Font.PMA.regular(size: .thirteen))
                    .foregroundColor(.secondary)
                
                FirmwareUpdatedSuccessfullyMsgView(firmwareVersion: firmwareVersion, newFirmware: newFirmware)
                
            }.padding(15)
                .multilineTextAlignment(.leading)
            
        }
    }
}

struct FirmwareUpdatedSuccessfullyView_Previews: PreviewProvider {
    static var previews: some View {
        FirmwareUpdatedSuccessfullyView(firmwareVersion: "1.2.3", newFirmware: "137")
    }
}
