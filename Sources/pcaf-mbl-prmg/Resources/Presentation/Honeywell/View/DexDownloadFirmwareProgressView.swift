//
//  DexDownloadFirmwareProgressView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 10/03/23.
//

import SwiftUI

struct DexDownloadFirmwareProgressView: View {
    @Binding var firmwareDownloadProgress: Double
    var firmwareVersion : String
    var newFirmware : String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text("\(PMAConstants.Titles.updateFirmwareTo) \(newFirmware)")
                    .font(Font.PMA.bold(size: .twelve))
                    .foregroundColor(.primary).padding(1)
                Text("\(PMAConstants.Titles.currentFirmware) \(firmwareVersion)")
                    .font(Font.PMA.regular(size: .ten))
                    .foregroundColor(.secondary).padding(1)
                HStack{
                    Image(systemName: PMAConstants.ImageName.cloudArrow).foregroundColor(.gray)
                    Text(String(format: PMAConstants.Titles.zeroPercent, firmwareDownloadProgress) + PMAConstants.Titles.percent)
                        .frame(width: 55).foregroundColor(PMAColor.blackWithOpacityPointFive)
                        .multilineTextAlignment(.leading)
                        .font(Font.PMA.regular(size: .fifteen))
                    ProgressView("", value: firmwareDownloadProgress, total: 100).padding(.init(top: -15, leading: 2, bottom:0 , trailing: 0))
                    Button(action: {
                        NotificationCenter.default.post(name: NSNotification.cancelDownloading, object: nil, userInfo: nil)
                    }) {
                        Image(systemName: PMAConstants.ImageName.xCircle).foregroundColor(.gray)
                    }
                }.padding(1)
            }.padding(15)
                .multilineTextAlignment(.leading)
        }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(PMAColor.white)
            .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct DexDownloadFirmwareProgressView_Previews: PreviewProvider {
    static var previews: some View {
        DexDownloadFirmwareProgressView(firmwareDownloadProgress: .constant(100), firmwareVersion: "1.2.3", newFirmware: "1.2.4")
    }
}
