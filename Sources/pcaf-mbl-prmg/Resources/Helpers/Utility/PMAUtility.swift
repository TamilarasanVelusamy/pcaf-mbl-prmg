//
//  PMAUtility.swift
//  pcaf-mbl-prmg
//
//  Created by tamilarasan_v on 09/10/24.
//

import Foundation
import SwiftUI
//import pcaf_mbl_auth

// Add feature keys
enum PMFeatureKeys: String {
    case scoreMyStore = "ScoreMyStoreKey"
    case smsNonMandatoryBuildingBlockKey = "SmsNonMandatoryBuildingBlockKey"
    case enableViewAccessSalesLeaders = "EnableViewAccessSalesLeadersKey"
    case peripheralManagementApp = "PeripheralManagementAppFeatureKey"
    case canadaExpansionFeatureKey = "CanadaExpansionFeatureKey"
    case cbLiteLoggingFeatureKey = "CBLiteLoggingFeatureKey"
}

class PMFeatureEnabler {
    static let sharedInstance = PMFeatureEnabler()
    func isFeatureEnabled(_ featureKey: String) -> Bool {
        guard let mySetting = Bundle.main.object(forInfoDictionaryKey: featureKey) as? String
        else {
            PMLog.shared.logger?.log(.verbose, message: "Bundle.main.object failure for \(featureKey)")
            return false }
        let isEnabled = mySetting == "true" ? true : false
        let logString = isEnabled ? "isFeatureEnabled" : "FeaturenotEnabled"
        PMLog.shared.logger?.log(.verbose, message: "\(featureKey) \(logString)")
        return isEnabled
    }
}



extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

struct DeviceSetting {
    static var deviceType: UIUserInterfaceIdiom {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        return deviceIdiom
    }
}

extension String {
    func toInt() -> Int {
    
        //TODO: add canadaLocaleID
        if Locale.current.identifier == PMConstant.canadaLocaleID {
           let double = Double(self)
          return double?.toIntRounded() ?? 0
       } else {
            return NumberFormatter().number(from: self)?.intValue ?? 0
        }
    }
}

extension Double {
    func toIntRounded() -> Int? {
        let roundedValue = rounded(.toNearestOrEven)
        return Int(exactly: roundedValue)
    }
}

extension Image {
    //MARK: Custom Navigation Bar - Image

    func backIcon() -> some View{
        self
            //.resizable()
            .frame(width: 10, height: DeviceSetting.deviceType == .phone ? 16 : 20)
    }
}

