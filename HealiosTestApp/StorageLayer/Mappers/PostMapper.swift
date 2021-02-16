//
//  PostMapper.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 16.02.2021.
//

import CoreData

class PostMapper: BaseMapper<ManagedPost, Post> {
    static var `default`: PostMapper { PostMapper() }

    func map(from dataEntity: ManagedPost, to businessEntity: inout Post) {
        businessEntity.id = Int(dataEntity.id)
        businessEntity.title = dataEntity.title!
        businessEntity.body = dataEntity.body!
        businessEntity.userId = Int(dataEntity.userId)
    }

    func map(from businessEntity: Post, to dataEntity: ManagedPost) {
        dataEntity.id = Int32(businessEntity.id)
        dataEntity.title = businessEntity.title
        dataEntity.body = businessEntity.body
        dataEntity.userId = Int32(businessEntity.userId)
    }
}
