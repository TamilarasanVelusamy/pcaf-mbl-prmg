//
//  ActivityIndicator.swift
//  DeviceManagerApp
//
//  Created by Anthony Hoepelman on 9/15/22.
//

import SwiftUI

struct PMAActivityIndicatorView: View {
    
    let message: String
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(PMAColor.white) 
            ProgressView(message)
                .padding()

            }.padding(.init(top: 0, leading: 15, bottom: 5 , trailing: 15))
             .fixedSize(horizontal: false, vertical: true)
    }
}


struct PMAActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        PMAActivityIndicatorView(message: "Please wait")
    }
}
