//
//  FWNavigationView.swift
//  SalesProPlus
//
//  Created by ketan on 10/11/22.
//

import SwiftUI

struct PMANavigationView: View {
    // Properties
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var rightBarButtonTitle: String?
    var navigationBarTitle: String
    var showLeftBarButton: Bool
    var showRightBarButton: Bool
    var backgroundColor: Color
    var isTabbar: Bool = false
    var leftBarButtonTitle: String?
    @Binding var enableNavigation: Bool
    
    var body: some View {
        ZStack {
            backgroundImageView()
            HStack(spacing: PMAConstants.Constants.Padding.zero.rawValue) {
                // Back navigation bar button
                backButtonView()
                Spacer()
                titleWifiView()
                Spacer()
                // Right bar button
                rightBarButtonView()
            }
            .padding(.top, PMAConstants.Constants.Padding.large.rawValue)
            .padding(.trailing, DeviceSetting.deviceType == .phone ? PMAConstants.Constants.Padding.zero.rawValue : PMAConstants.Constants.Padding.large.rawValue)
            .padding(.bottom, PMAConstants.Constants.Padding.large.rawValue)
        }
        .padding(.top, PMAConstants.Constants.Padding.large.rawValue)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(PMAColor.primaryThemeColor)
    }
}

// MARK: Left navigation bar button
extension PMANavigationView {
    // Back button icon
    func backgroundImageView() -> some View {
        Image( DeviceSetting.deviceType == .phone ? PMAConstants.ImageName.homeNavigationBg : PMAConstants.ImageName.homeNavigationBgIPad)
            .resizable()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
    }
    // Back button view
    func backButtonView()  -> some  View {
        HStack {
            if showLeftBarButton {
                Button {
                    if isTabbar {
                        NavigationUtil.popToRootView()
                    }
                    else {
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Image(systemName: PMAConstants.ImageName.backIcon)
                        .backIcon()
                        .padding(.leading, DeviceSetting.deviceType == .phone ? PMAConstants.Constants.Padding.medium.rawValue : PMAConstants.Constants.Padding.large.rawValue)
                    Text(leftBarButtonTitle ?? "")
                        .font(Font.PMA.regular(size: .seventeen))
                }
            }
        }
        .frame(width: DeviceSetting.deviceType == .phone ? 80 : 200, alignment: .leading)
        .foregroundColor(PMAColor.white)
    }
}
// MARK: Right navigation bar button
extension PMANavigationView {
    func rightBarButtonView() -> some  View {
        HStack {
            if rightBarButtonTitle == nil && showRightBarButton {
                Image(systemName: PMAConstants.ImageName.syncIcon)
                    .frame(width: 50, height: 50   )
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(PMAColor.white)
                    .onTapGesture {
                        NotificationCenter.default.post(name: NSNotification.refreshButtonClicked, object: nil, userInfo: nil)
                    }
            } else {
                Text(rightBarButtonTitle ?? "")
                    .foregroundColor(showRightBarButton ? PMAColor.white : PMAColor.white.opacity(0.5))
                    .font(Font.PMA.regular(size: .seventeen))
                    .onTapGesture {
                        if rightBarButtonTitle == PMAConstants.Titles.save && showRightBarButton {
                            NotificationCenter.default.post(name: NSNotification.saveRecipeAlert, object: nil, userInfo: nil)
                        } else if rightBarButtonTitle == PMAConstants.Titles.saveUpdates && showRightBarButton {
                            NotificationCenter.default.post(name: NSNotification.updateRecipeAlert, object: nil, userInfo: nil)
                        } else if rightBarButtonTitle == PMAConstants.Titles.submit {
                            NotificationCenter.default.post(name: NSNotification.submitAlert, object: nil, userInfo: nil)
                        } else {
                            enableNavigation = showRightBarButton ? true : false
                        }
                    }
            }
        }
        .frame(width: DeviceSetting.deviceType == .phone ? 80 : 200, alignment: .trailing)
    }
}
// MARK: Navigation bar title
extension PMANavigationView {
    func titleWifiView() -> some View {
        HStack(spacing: PMAConstants.Constants.Padding.zero.rawValue) {
            Text(navigationBarTitle)
                .font(Font.PMA.displayBold(size: DeviceSetting.deviceType == .phone ? .seventeen : .twenty))
                .foregroundColor(PMAColor.white)
                .multilineTextAlignment(.center)
        }.frame(maxWidth: .infinity, alignment: .center)
    }
}
