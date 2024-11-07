//
//  NavigationUtil.swift
//  SalesProPlus
//
//  Created by Shatadru Datta on 01/06/22.
//

import Foundation
import UIKit

struct NavigationUtil {
    static func popToRootView() {
        if let window = UIApplication.shared.currentUIWindow() {
            findNavigationController(viewController: window.rootViewController)?.popToRootViewController(animated: true)
        } else {
            PMLog.shared.logger?.log(.verbose, message: "window found nil popToRootView")
        }
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            PMLog.shared.logger?.log(.verbose, message: "viewController found nil findNavigationController")
            return nil
        }

        if let navigationController = viewController as? UINavigationController {
            return navigationController
        } else {
            PMLog.shared.logger?.log(.verbose, message: "navigationController found nil findNavigationController")
        }

        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        PMLog.shared.logger?.log(.verbose, message: "viewController.children found empty or nil findNavigationController")
        return nil
    }
}

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
        
    }
}
