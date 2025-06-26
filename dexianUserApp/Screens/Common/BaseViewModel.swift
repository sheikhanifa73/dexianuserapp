//
//  BaseViewModel.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation


class BaseViewModel {
    weak var view: BaseViewProtocol?
    
    init(view: BaseViewProtocol) {
        self.view = view
    }
    
    func showLoading() {
        view?.showLoading()
    }
    
    func hideLoading() {
        view?.hideLoading()
    }
    
    func handleError(_ error: Error) {
        let errorMessage = error.localizedDescription.isEmpty ? "An unexpected error occurred. Please try again." : error.localizedDescription
        view?.showError(errorMessage)
    }
    
    // Convenience method for NetworkError
    func handleNetworkError(_ error: NetworkError) {
        view?.showError(error.localizedDescription)
    }
}
