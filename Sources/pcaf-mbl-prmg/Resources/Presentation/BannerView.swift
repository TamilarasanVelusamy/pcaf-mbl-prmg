//
//  DMTileButton.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 01/12/22.
//

import SwiftUI

struct Banner: Identifiable {
  let id = UUID()
  let title: String
  let updateCount: Int
}

public struct BannerView: View {
    var banners: Banner
    public init () {
        banners = Banner(title: PMAConstants.Titles.peripheralManagement, updateCount: PMPushHandler().updateCount )
    }
    
 public  var body: some View {
             NavigationLink(destination:
                                PMADeviceListView().navigationBarBackButtonHidden(true)) {
                 ZStack(alignment: .center) {
                     RoundedRectangle(cornerRadius: 12, style: .continuous)
                         .fill(PMAColor.peripheralViewColor).shadow(color: PMAColor.cardShadow, radius: 2, x: 0, y: 2)
                         .frame(height: 40)
                     VStack(alignment: .center) {
                         HStack(alignment: .center) {
                             Text(banners.title)
                                 .font(Font.PMA.normal(size: .fifteen))
                                 .foregroundColor(PMAColor.black)
                                 .multilineTextAlignment(.leading)
                             Spacer()
                             Text("\(banners.updateCount) Updates")
                                 .font(Font.PMA.normal(size: .thirteen))
                                 .foregroundColor(PMAColor.white)
                                 .frame(width: 76,height: 26).background(.blue).cornerRadius(3)
                             Spacer()
                             Image(systemName: PMAConstants.ImageName.chevronForword)
                                 .frame(width: 24,height: 24)
                                 .foregroundColor(PMAColor.black)
                         }
                     }
                     .padding(15)
                     
                 }
                 .padding(15)
                 .padding(.bottom, 15)
             }
                            
    }
    
    func checkUpdate() -> Bool{
        if banners.updateCount > 0 {
           // isUpdateAvailable = true
            return true
        } else{
            
            return false
        }
    }
    
}
