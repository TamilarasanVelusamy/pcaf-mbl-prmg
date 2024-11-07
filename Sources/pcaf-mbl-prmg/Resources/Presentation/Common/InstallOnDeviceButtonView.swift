//
//  InstallOnDeviceButtonView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 12/29/22.
//

import SwiftUI

struct InstallOnDeviceButtonView: View {
    
    @Binding var showFWUpdateAlert : Bool
    
    var body: some View {
        
        Button(action: {
            showFWUpdateAlert.toggle()
        }) {
            Text(PMAConstants.Titles.installOnDevice)
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
}

struct InstallOnDeviceButtonView_Previews: PreviewProvider {
    static var previews: some View {
        InstallOnDeviceButtonView(showFWUpdateAlert: .constant(false))
    }
}
