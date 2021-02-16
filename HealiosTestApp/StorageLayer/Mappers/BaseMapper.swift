//
//  BaseMapper.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 16.02.2021.
//

import Foundation
import CoreData

protocol EntityBase {
    var id: Int { get set }
}

class BaseMapper<T: NSManagedObject, E: EntityBase> {
}
