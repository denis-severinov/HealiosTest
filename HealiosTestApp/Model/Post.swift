//
//  Post.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 12.02.2021.
//

import Foundation

typealias Posts = [Post]

struct Post: Codable, EntityBase {
    var id: Int
    var userId: Int
    var title: String
    var body: String
    
    init() {
        self.id = -1
        self.userId = -1
        self.title = ""
        self.body = ""
    }
}
