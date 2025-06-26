//
//  User.swift
//  dexianUser
//
//  Created by sheik hanifa on 26/06/25.
//

struct User: Codable {
    let id: Int?
    var name: String
    var email: String
    var gender: Gender
    var status: Status
    
    enum Gender: String, Codable, CaseIterable {
        case male = "male"
        case female = "female"
        
        var displayName: String {
            rawValue.capitalized
        }
    }
    
    enum Status: String, Codable, CaseIterable {
        case active = "active"
        case inactive = "inactive"
        
        var displayName: String {
            rawValue.capitalized
        }
    }
}
