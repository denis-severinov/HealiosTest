//
//  Comment.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 12.02.2021.
//

import Foundation

typealias Comments = [Comment]

struct Comment: Codable, EntityBase {
    var id, postId: Int
    var name, email, body: String
    
    init() {
        self.id = -1
        self.postId = -1
        self.name = ""
        self.email = ""
        self.body = ""
    }
}
