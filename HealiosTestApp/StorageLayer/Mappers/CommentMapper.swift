//
//  CommentMapper.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 16.02.2021.
//

import CoreData

class CommentMapper: BaseMapper<ManagedComment, Comment> {
    static var `default`: CommentMapper { CommentMapper() }
    
    func map(from dataEntity: ManagedComment, to businessEntity: inout Comment) {
        businessEntity.id = Int(dataEntity.id)
        businessEntity.name = dataEntity.name!
        businessEntity.body = dataEntity.body!
        businessEntity.email = dataEntity.email!
        businessEntity.postId = Int(dataEntity.postId)
    }

    func map(from businessEntity: Comment, to dataEntity: ManagedComment) {
        dataEntity.id = Int32(businessEntity.id)
        dataEntity.name = businessEntity.name
        dataEntity.body = businessEntity.body
        dataEntity.email = businessEntity.email
        dataEntity.postId = Int32(businessEntity.postId)
    }
}
