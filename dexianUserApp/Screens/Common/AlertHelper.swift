//
//  AlertHelper.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import UIKit

class AlertHelper {
    static func showAlert(on viewController: UIViewController, title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.ok, style: .default) { _ in
            completion?()
        })
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
    
    static func showConfirmationAlert(on viewController: UIViewController, title: String, message: String, confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel))
        alert.addAction(UIAlertAction(title: StringConstants.ok, style: .destructive) { _ in
            confirmAction()
        })
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
    
    static func showActionSheet(on viewController: UIViewController, title: String, message: String? = nil, actions: [(title: String, style: UIAlertAction.Style, handler: () -> Void)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        actions.forEach { action in
            alert.addAction(UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler()
            })
        }
        
        alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel))
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
}
