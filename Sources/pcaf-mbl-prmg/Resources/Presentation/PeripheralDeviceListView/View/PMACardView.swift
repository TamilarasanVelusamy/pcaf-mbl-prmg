//
//  FWCardView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 12/12/22.
//

import SwiftUI

struct PMACardView: View {
    var device: PeripheralDeviceModel
    
    /// Designing for card view.
    var body: some View {
        
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(PMAColor.white).shadow(color: PMAColor.cardShadow, radius: 2, x: 0, y: 2)
                    .overlay {
                        VStack{
                            switch device.deviceName {
                            case PMAConstants.Titles.brother:
                                NavigationLink(destination: BrotherHomeView().hiddenNavigationBarStyle()){
                                    PMACardSubView(device: device)
                                }
                            case PMAConstants.Titles.unitech:
                                NavigationLink(destination: UnitechHomeView().hiddenNavigationBarStyle()){
                                    PMACardSubView(device: device)
                                }
                            default:
                                PMACardSubView(device: device)
                            }
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 142)
            }
        }
    
}

struct PMACardView_Previews: PreviewProvider {
    static var previews: some View {
        PMACardView(device: PeripheralDeviceModel(deviceType: "Printer", deviceName: "Brother", deviceConnected: false, deviceImage: Image(.brotherRJ42308)))
    }
}

struct PMACardSubView: View {
    var device: PeripheralDeviceModel
    var body: some View {
        VStack{
            ZStack{
                Image("")
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(PMAColor.borderLightGray, lineWidth: 1))
                switch device.deviceType {
                case "Printer" :
                    Image(.brotherRJ42308)
                        .resizable()
                        .frame(width: 64, height: 64, alignment: .center)
                case "Scanner" :
                    Image(.uteScanner)
                        .resizable()
                        .frame(width: 64, height: 64, alignment: .center)
                default :
                    Image(.dex)
                        .resizable()
                        .frame(width: 64, height: 64, alignment: .center)
                }
            }
            Text(device.deviceType).foregroundColor(PMAColor.black)
                .font(Font.PMA.semiBold(size: .fifteen))
                .padding(.top, DeviceSetting.deviceType  == .phone ? PMAConstants.Constants.Padding.small.rawValue : PMAConstants.Constants.Padding.large.rawValue)
            }
    }
    
}
