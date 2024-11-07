//
//  CommonExtension.swift
//  DeviceManagementApp
//
//  Created by ketan on 18/08/22.
//

import Foundation
import UIKit

extension Int32 {
    
    /// Convert Int32 to bool value
    var boolValue: Bool {
        return (self as NSNumber).boolValue
    }
}

protocol PMAConvertable: Codable {

}

extension PMAConvertable {
    
    /// Convert Json object to dictionary
    /// - Returns: Dictionary
    func convertToDict() -> Dictionary<String, Any>? {
        var dict: Dictionary<String, Any>? = nil
        do {
            let encoder = JSONEncoder()

            let data = try encoder.encode(self)
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
        } catch {
            PMLog.shared.logger?.log(.verbose, message: "PM Dict Extension :\(error)")
        }
        return dict
    }
}

extension UIApplication {
    
    /// Get top view controller
    static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension URL    {
    
    /// Check path exists in file directory
    /// - Returns: Bool
    func checkFileExist() -> Bool {
        let path = self.path
        if (FileManager.default.fileExists(atPath: path))   {
            PMLog.shared.logger?.log(.verbose, message: "File path available")
            return true
        }else        {
            PMLog.shared.logger?.log(.verbose, message: "File path not available")
            return false;
        }
    }
}

extension NSNotification {
    static let refreshButtonClicked = Notification.Name.init("refreshButtonClicked")
    static let saveRecipeAlert = Notification.Name.init("SaveRecipeAlert")
    static let updateRecipeAlert = Notification.Name.init("UpdateRecipeAlert")
    static let submitAlert = Notification.Name.init("SubmitAlert")
}
