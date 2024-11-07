//
//  iOSBatteryLevel.swift
//  DeviceManagerApp
//
//  Created by anthony.hoepelman on 9/22/22.
//

import Foundation
import SwiftUI

class IosBatteryLevel: ObservableObject {
    
    // MARK: - Published
    
    @Published var batteryLevel: Int = 0
    @Published var batteryStateDescription: String = ""
    
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        self.batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        setBatteryState()
        
        /// Notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange(notification:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange(notification:)), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    //MARK: - Notification Center observers function
        
    @objc func batteryLevelDidChange(notification: Notification) {
        self.batteryLevel = Int(UIDevice.current.batteryLevel * 100)
    }
    
    @objc func batteryStateDidChange(notification: Notification) {
        setBatteryState()
    }
    
    //MARK: - User defined function for checking Battery state
    
    private func setBatteryState() {
        let batteryState = UIDevice.current.batteryState
        self.batteryStateDescription = getBatteryDescription(for: batteryState)
    }
    
    func getBatteryDescription(for state: UIDevice.BatteryState) -> String {
        switch state {
        case .unplugged:
            return PMAConstants.Titles.onBatteryPower
        case .charging:
            return PMAConstants.Titles.charging
        case .full:
            return PMAConstants.Titles.fullCharged
        case .unknown:
            return PMAConstants.ErrorMessage.unknown
        @unknown default:
            return PMAConstants.ErrorMessage.unknown
        }
    }
}
