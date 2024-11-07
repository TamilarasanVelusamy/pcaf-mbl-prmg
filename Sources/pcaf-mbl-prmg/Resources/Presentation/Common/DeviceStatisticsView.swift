//
//  DeviceStaticsView.swift
//  TestImageList
//
//  Created by amit.verma08 on 10/11/22.
//

import SwiftUI

struct DeviceStatisticsView : View{
    
    var batteryLevel : String
    var version : String
    
    var body: some View{
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 4)  {
                Text(PMAConstants.Titles.deviceStatistics)
                    .font(Font.PMA.semiBold(size: .fifteen))
                    .foregroundColor(.primary)
                VStack(alignment: .leading){
                    Text("\(PMAConstants.Titles.battery) \(batteryLevel)%")
                        .font(Font.PMA.regular(size: .thirteen))
                        .foregroundColor(.secondary)
                    Text("\(PMAConstants.Titles.hardwareVersion) \(version)")
                        .font(Font.PMA.regular(size: .thirteen))
                        .foregroundColor(.secondary)
                        .hidden(version == "" ? true : false)
                }
                Spacer()
            }.padding(16)
                .multilineTextAlignment(.leading)
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct DeviceStaticView_Previews: PreviewProvider {
    
    static var previews: some View {
        DeviceStatisticsView(batteryLevel: "0", version: "1.2.3")
    }
}
