//
//  UserMapper.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 16.02.2021.
//

import CoreData

class UserMapper: BaseMapper<ManagedUser, User> {
    static var `default`: UserMapper { UserMapper() }

    func map(from dataEntity: ManagedUser, to businessEntity: inout User) {
        businessEntity.id = Int(dataEntity.id)
        businessEntity.name = dataEntity.name!
        businessEntity.username = dataEntity.username!
        businessEntity.phone = dataEntity.phone!
        businessEntity.email = dataEntity.email!
        businessEntity.website = dataEntity.website!
    }

    func map(from businessEntity: User, to dataEntity: ManagedUser) {
        dataEntity.id = Int32(businessEntity.id)
        dataEntity.name = businessEntity.name
        dataEntity.username = businessEntity.username
        dataEntity.phone = businessEntity.phone
        dataEntity.email = businessEntity.email
        dataEntity.website = businessEntity.website
    }
}
