//
//  ManagedUser+CoreDataProperties.swift
//  
//
//  Created by Denis Severinov on 15.02.2021.
//
//

import Foundation
import CoreData


extension ManagedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedUser> {
        return NSFetchRequest<ManagedUser>(entityName: "ManagedUser")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var website: String?
    @NSManaged public var posts: ManagedPost?
    @NSManaged public var comments: ManagedComment?

}
