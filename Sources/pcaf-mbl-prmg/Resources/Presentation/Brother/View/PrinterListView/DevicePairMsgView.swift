//
//  DevicePairMsgView.swift
//  pcaf-mbl-prmg
//
//  Created by tamilarasan_v on 16/10/24.
//

import Foundation
import SwiftUI

struct DevicePairMsgView: View {
    var message: String
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            HStack {
                
                Group {
                    Image(systemName: PMAConstants.ImageName.exclamationmarkCircle)
                        .foregroundColor(.secondary)
                    
                    Text(message)
                        .font(Font.PMA.regular(size: .thirteen))
                        .foregroundColor(.secondary)
                }.frame(maxHeight: 30, alignment: .bottom)
            }
        }
    }
}

struct DevicePairMsgView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePairMsgView(message: PMAConstants.Titles.printerTurnedOn)
    }
}
