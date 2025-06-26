//
//  SplashViewModel.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

class SplashViewModel {
    // MARK: - Properties
    var onCompletion: (() -> Void)?
    
    // MARK: - Methods
    func initialize() {
        Logger.log("Splash screen initialized")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.Animation.splashDelay) {
            self.onCompletion?()
        }
    }
}
