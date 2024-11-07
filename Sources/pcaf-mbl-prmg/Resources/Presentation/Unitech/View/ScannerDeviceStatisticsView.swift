//
//  ScannerDeviceStatisticsView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 12/30/22.
//

import SwiftUI

struct ScannerDeviceStatisticsView: View {
    var batteryLevel : Int?
    var version : String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading , spacing: 4) {
                
                Text(PMAConstants.Titles.deviceStatistics)
                    .font(Font.PMA.semiBold(size: .fifteen))
                    .foregroundColor(.primary)
                VStack(alignment: .leading ) {
                    Text("\(PMAConstants.Titles.battery) \(batteryLevel ?? 0)%")
                        .font(Font.PMA.regular(size: .thirteen))
                        .foregroundColor(.secondary)
                    Text("\(PMAConstants.Titles.hardwareVersion) \(version)")
                        .font(Font.PMA.regular(size: .thirteen))
                        .foregroundColor(.secondary)
                        .hidden(version == "" ? true : false)
                }
            } .padding(15)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .background(PMAColor.white)
        .shadow(color: PMAColor.lineShadow, radius: 2, x: 0, y: 2)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ScannerDeviceStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerDeviceStatisticsView(batteryLevel: 65, version: "1.2.3")
    }
}
