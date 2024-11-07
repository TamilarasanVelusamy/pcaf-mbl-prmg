//
//  PairderPrinterListView.swift
//  DeviceManagerApp
//
//  Created by ketan on 19/09/22.
//

import SwiftUI

struct PairedPrinterListView: View {
    var printerModel: PrinterModel
    
    /** Designing of CardView **/
    var body: some View {
        ZStack {
            /// Creates a background cardview with shadow
            ///- Parameter cornerRadius: set radius of view
            /// - Returns: shape
            
            HStack(alignment: .top) {
                ZStack{
                    Image("")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(PMAColor.borderLightGray, lineWidth: 1))
                    Image(.brotherRJ42308)
                        .resizable()
                        .frame(width: 64, height: 64)
                }
                .padding(.trailing, 10)

                VStack(alignment: .leading, spacing: 4) {
                    Text(printerModel.printerName ?? "")
                        .font(Font.PMA.semiBold(size: .fifteen))
                        .frame(minHeight: 20)
                    Text("\(PMAConstants.Titles.sortSerialNumber) \(printerModel.serialNumber ?? "")")
                        .font(Font.PMA.regular(size: .thirteen))
                        .foregroundColor(PMAColor.gray)
                        .frame(height: 20)
                    HStack{
                        Image(systemName: PMAConstants.ImageName.circle)
                            .resizable()
                            .frame(width: 8, height: 8)
                            .foregroundColor(printerModel.deviceConnected == true ? PMAColor.green : PMAColor.gray)
                        Text(printerModel.deviceConnected == true ? PMAConstants.Titles.connected : PMAConstants.Titles.disconnected)
                            .font(Font.PMA.regular(size: .thirteen))
                            .foregroundColor(printerModel.deviceConnected == true ? PMAColor.green : PMAColor.gray)
                    }.padding(.init(top: 2, leading: 0, bottom: 0 , trailing: 0))
                }.multilineTextAlignment(.leading)
                Spacer()
                
            }
            NavigationLink("", destination: PrinterDetailsView(printerModel: printerModel))
        }
        .background(PMAColor.white)

    }
}

struct PairderPrinterListView_Previews: PreviewProvider {
    static var previews: some View {
        
        PairedPrinterListView(printerModel: PrinterModel(serialNumber: " SEFFR44T5", printerName: "Brother Printer - RJ3420J"))
            .padding()
            .frame(height: 150)
            .background(PMAColor.appBackground)

    }
}
