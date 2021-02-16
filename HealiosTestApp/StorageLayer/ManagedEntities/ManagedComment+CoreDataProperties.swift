//
//  ManagedComment+CoreDataProperties.swift
//  
//
//  Created by Denis Severinov on 15.02.2021.
//
//

import Foundation
import CoreData


extension ManagedComment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedComment> {
        return NSFetchRequest<ManagedComment>(entityName: "ManagedComment")
    }

    @NSManaged public var id: Int32
    @NSManaged public var postId: Int32
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var body: String?

}
