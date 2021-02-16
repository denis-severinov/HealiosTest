//
//  ManagedPost+CoreDataProperties.swift
//  
//
//  Created by Denis Severinov on 15.02.2021.
//
//

import Foundation
import CoreData


extension ManagedPost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPost> {
        return NSFetchRequest<ManagedPost>(entityName: "ManagedPost")
    }

    @NSManaged public var id: Int32
    @NSManaged public var userId: Int32
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var comments: ManagedComment?

}
