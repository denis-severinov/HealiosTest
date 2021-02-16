//
//  User.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 12.02.2021.
//

import Foundation

typealias Users = [User]

struct User: Codable, EntityBase {
    var id: Int
    var name, username, email, phone, website: String
    
    init() {
        self.id = -1
        self.name = ""
        self.username = ""
        self.email = ""
        self.phone = ""
        self.website = ""
    }
}

extension User: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
