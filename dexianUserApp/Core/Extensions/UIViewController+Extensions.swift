//
//  UIViewController+Extensions.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.ok, style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    func showError(_ error: NetworkError) {
        showAlert(title: StringConstants.error, message: error.localizedDescription)
    }
}
