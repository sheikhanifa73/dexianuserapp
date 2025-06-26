//
//  String+Extensions.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", StringConstants.Validation.emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isNotEmpty: Bool {
        return !trimmed.isEmpty
    }
    
    func isValidName() -> Bool {
        let length = trimmed.count
        return length >= StringConstants.Validation.nameMinLength &&
               length <= StringConstants.Validation.nameMaxLength
    }
    
    func capitalized() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
