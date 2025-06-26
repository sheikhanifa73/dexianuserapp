//
//  BaseViewProtocol.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

protocol BaseViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)  // Changed to String
    func showSuccess(_ message: String)
}
