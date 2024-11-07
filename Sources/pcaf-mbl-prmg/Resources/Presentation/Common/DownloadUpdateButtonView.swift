//
//  DownloadUpdateButtonView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 12/30/22.
//

import SwiftUI

struct DownloadUpdateButtonView: View {
    @State var showAlert = false
    var body: some View {
        
        VStack(spacing :20) {
            Button(action: {
                if(PMADownloadManager.shared.currentDownloads().count == 0){
                    showAlert = false
                    NotificationCenter.default.post(name: NSNotification.downloadFirmwareFile, object: nil, userInfo: nil)
                }else{
                    showAlert = true
                }
            }) {
                HStack{
                    Spacer()
                    Image(systemName: PMAConstants.ImageName.cloudArrow)
                        .resizable()
                        .frame(width: 20, height: 18)
                        .foregroundColor(PMAColor.white)
                        .padding()
                    
                    Text(PMAConstants.Titles.downloadUpdate)
                        .frame(height: 50)
                        .font(Font.PMA.bold(size: .seventeen))
                        .foregroundColor(PMAColor.white)
                    Spacer()
                }
            }.alert(isPresented: $showAlert, content: {
                Alert(title: Text(PMAConstants.Titles.downloadMessage))
            })
            .background(PMAColor.ctablue)
            .cornerRadius(10)
        }
    }
}

struct DownloadUpdateButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadUpdateButtonView()
    }
}
