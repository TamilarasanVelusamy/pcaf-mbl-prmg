//
//  ConnectForFirmwareView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 12/29/22.
//

import SwiftUI

struct ConnectForFirmwareView: View {
    var body: some View {
        HStack {
            Text(PMAConstants.ImageName.warning+PMAConstants.Titles.infoFwInstallation)
                .font(Font.PMA.regular(size: .eleven))
                .foregroundColor(PMAColor.darkRed)
        }
    }
}

struct ConnectForFirmwareView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectForFirmwareView()
    }
}
