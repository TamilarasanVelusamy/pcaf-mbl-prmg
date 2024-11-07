//
//  DexDeviceUnpairView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 21/02/23.
//

import SwiftUI

struct DeviceUnpairView: View {
    @State var header = ""
    @State var title = ""
    @State var message = ""
    @State var showAlert = false
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
        
                
                Button(action: {
                    showAlert.toggle()
                }) {
                    Text(header)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(Font.PMA.semiBold(size: .seventeen))
                        .padding()
                        .foregroundColor(header == PMAConstants.Titles.pair ? PMAColor.white : PMAColor.darkRed)
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: CGFloat(PMAConstants.Button.cornerRadius))
                        .stroke(header == PMAConstants.Titles.pair ? PMAColor.ctablue : PMAColor.darkRed, lineWidth: CGFloat(PMAConstants.Button.borderWidth))
                )
                .background(header == PMAConstants.Titles.pair ? PMAColor.ctablue : PMAColor.white)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(title), message: Text(message),
                          primaryButton: .default (Text(PMAConstants.Titles.cancel)) {},
                          secondaryButton: .default (Text(PMAConstants.Titles.settings)) {
                        //for bluetooth setting
                        let url = URL(string: "App-Prefs:root=Bluetooth")
                        UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                            
                        })
                    }
                    )
                }
                .cornerRadius(10)
                .padding(10)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .background(PMAColor.white)
           
        }
}

struct DeviceUnpairView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceUnpairView(header:PMAConstants.Titles.unpair,title: PMAConstants.Titles.unpairBrother,message: PMAConstants.Titles.brotherUnpairMsg)
            .background(PMAColor.black)
    }
}
