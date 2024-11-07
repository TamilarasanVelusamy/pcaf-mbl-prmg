//
//  DMCustomAlertView.swift
//  SalesProPlus
//
//  Created by hitendra.kumar on 23/11/22.
//

import SwiftUI

struct PMACustomAlertView: View {
    
    var title: String
    var message: String
    var firstButton: String
    var secondButton: String?
    var secondButtonType: String?
    var showSecondButton: Bool
    var titleBackgroundColor: Color
    var titleForegroundColor: Color
    var showInputField: Bool?
    var inputFieldPlaceholder: String?

    @Binding var showAlert: Bool

    @State var name: String = ""

    var body: some View {
        ZStack {
            //Custom alert view
            VStack(alignment: .center, spacing: PMAConstants.Constants.Padding.zero.rawValue) {
                //Alert title
                HStack(alignment: .center) {
                    Text(title)
                        .font(Font.PMA.semiBold(size: .seventeen))
                        .foregroundColor(titleForegroundColor)
                }
                .frame(maxWidth: .infinity)
                .frame(height: PMAConstants.Constants.Size.fortyOne.rawValue, alignment: .center)
                .background(titleBackgroundColor)

                //Alert Message
                VStack(alignment: .center) {
                    if (showInputField ?? false) {
                        TextField(inputFieldPlaceholder ?? "", text: $name)
                            .padding(.leading, PMAConstants.Constants.Padding.standard.rawValue)
                            .background(PMAColor.white)
                            .frame(height: PMAConstants.Constants.Size.forty.rawValue)
                            .overlay(
                                    RoundedRectangle(cornerRadius: PMAConstants.Constants.Radius.five.rawValue)
                                        .stroke(PMAColor.recipeListBorder.opacity(PMAColor.colorOpacity.zeroPointFive), lineWidth: PMAConstants.Constants.Size.one.rawValue)
                                )
                            .accentColor(.blue)
                    } else {
                        Text(message)
                            .font(Font.PMA.regular(size: .sixteen))
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(PMAConstants.Constants.Padding.medium.rawValue)
                Divider()

                if showSecondButton {
                    //Alert Button
                    HStack(alignment: .center, spacing: PMAConstants.Constants.Padding.zero.rawValue) {
                        //First Button view
                        Button {
                            showAlert.toggle()
                        } label: {
                            Text(firstButton)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                        Divider()
                            .frame(width: PMAConstants.Constants.Size.two.rawValue)
                            .frame(maxHeight: .infinity)

                        //Second button view
                        Button {
                            if secondButtonType?.lowercased() == PMAConstants.Constants.printerInstall.lowercased() {
                                NotificationCenter.default.post(name: NSNotification.installPrinterFirmware, object: nil, userInfo: nil)
                            }
                            if secondButtonType?.lowercased() == PMAConstants.Constants.dexInstall.lowercased() {
                                NotificationCenter.default.post(name: NSNotification.installFirmware, object: nil, userInfo: nil)
                            }
                            if secondButtonType?.lowercased() == PMAConstants.Constants.scannerInstall.lowercased() {
                                NotificationCenter.default.post(name: NSNotification.installScannerFirmware, object: nil, userInfo: nil)
                            }
                            showAlert.toggle()
                        } label: {
                            Text(secondButton ?? "")
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: PMAConstants.Constants.Size.fortyFour.rawValue, alignment: .bottom)
                    .font(Font.PMA.regular(size: .seventeen))
                    .foregroundColor(PMAColor.mediumBlue)
                } else {
                    HStack(alignment: .center) {
                        //Alert Button
                        Button {
                                showAlert.toggle()
                        } label: {
                            Text(firstButton)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: PMAConstants.Constants.Size.fortyFour.rawValue, alignment: .bottom)
                    .font(Font.PMA.regular(size: .seventeen))
                    .foregroundColor(PMAColor.mediumBlue)
                }
            }
            .frame(width: PMAConstants.Constants.Size.threeHundredTwentyFive.rawValue)
            .background(PMAColor.white)
            .cornerRadius(PMAConstants.Constants.Radius.twelve.rawValue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary.opacity(PMAColor.colorOpacity.zeroPointFive))
    }
}
