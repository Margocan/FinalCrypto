//
//  SceneDelegate.swift
//  CryptoTracker
//
//  Created by Margarita Can on 18.03.2024.
//

import UIKit

protocol AlertShowable {
    func showAlert(with message: String, title: String, buttonTitle: String, action: @escaping () -> ()?)
}

final class AlertManager: AlertShowable {
    
    private init() { }
    
    static let shared: AlertManager = .init()
    
    func showAlert(with message: String, title: String, buttonTitle: String, action: @escaping () -> ()?) {
        let alert = UIAlertController(
            title: title,
            message: message.description,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: { _ in
            action()
        }))

        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: true)
        }
    }
}

///Helper Extension to get topViewController
extension UIApplication {
    public class func topViewController(base: UIViewController? =
        UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
