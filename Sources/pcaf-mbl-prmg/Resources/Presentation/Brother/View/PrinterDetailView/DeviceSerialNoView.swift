//
//  DefaultToggleView.swift
//  TestImageList
//
//  Created by amit.verma08 on 10/11/22.
//

import SwiftUI

struct DeviceSerialNoView : View{
    
    var serialNumber : String
    
    var body: some View{
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 4)  {
                Text(PMAConstants.Titles.serialNumber)
                    .font(Font.PMA.semiBold(size: .fifteen))
                    .foregroundColor(.primary)
                VStack(alignment: .leading){
                    Text(serialNumber)
                        .font(Font.PMA.regular(size: .thirteen))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }.padding(16)
                .multilineTextAlignment(.leading)
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DeviceSerialNoView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSerialNoView(serialNumber: "XVXVXV")
    }
}

