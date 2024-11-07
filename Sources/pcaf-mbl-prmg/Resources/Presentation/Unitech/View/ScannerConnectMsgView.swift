//
//  ScannerConnectMsgView.swift
//  SalesProPlus
//
//  Created by anthony.hoepelman on 1/31/23.
//

import SwiftUI
import UIKit

struct ScannerConnectMsgView: View {
    var message = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                Group {
                    Image(systemName: PMAConstants.ImageName.exclamationmarkCircle)
                        .foregroundColor(.secondary)
                    
                    Text(message)
                        .font(Font.PMA.regular(size: .thirteen))
                        .foregroundColor(.secondary)
                }.frame(maxHeight: 25, alignment: .bottom)
            }
        }
    }
}

struct ScannerConnectMsgView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerConnectMsgView(message: PMAConstants.Titles.scannerEnsurePlugged)
    }
}
