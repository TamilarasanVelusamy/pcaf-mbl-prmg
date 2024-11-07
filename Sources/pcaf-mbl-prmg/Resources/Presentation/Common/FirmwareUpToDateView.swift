//
//  FirmwareUpToDateView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 12/30/22.
//

import SwiftUI

struct FirmwareUpToDateView: View {

    var firmwareVersion : String
    
    var body: some View{
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text(PMAConstants.Titles.firmwareUptoDate)
                    .font(Font.PMA.bold(size: .fifteen))
                    .foregroundColor(.primary).padding(1)
                Text("\(PMAConstants.Titles.currentFirmware) \(firmwareVersion)")
                    .font(Font.PMA.regular(size: .thirteen))
                    .foregroundColor(.secondary)
                Spacer()
            }.padding(15)
                .multilineTextAlignment(.leading)
            
        }
    }
}

struct FirmwareUpToDateView_Previews: PreviewProvider {
    static var previews: some View {
        FirmwareUpToDateView(firmwareVersion: "1.2.3")
    }
}

