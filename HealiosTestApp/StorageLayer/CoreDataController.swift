//
//  CoreDataController.swift
//  HealiosTestApp
//
//  Created by Denis Severinov on 15.02.2021.
//

import Foundation
import CoreData
import RxSwift

enum RepositoryError: Error {
    case failedToInsertObject
    case failedToUpdateObject
}

final class CoreDataController {
    static var shared: CoreDataController = {
        CoreDataController()
    }()
    
    private var persistentContainer: NSPersistentContainer
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {
        self.persistentContainer = {
            let container = NSPersistentContainer(name: "HealiosTestApp")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    }
    
    func createManagedObject<T: NSManagedObject>(ofType objectType: T.Type) -> T? {
        NSEntityDescription.insertNewObject(forEntityName: String(describing: objectType), into: context) as? T
    }
    
    func fetchManagedObjects<T: NSManagedObject>(ofType objectType: T.Type, includeSubentities: Bool = true, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int = 0) -> [T] {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: objectType))
        fetchRequest.predicate = predicate
        fetchRequest.includesSubentities = includeSubentities
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchLimit = fetchLimit
        
        let result = try? context.fetch(fetchRequest)
        
        return result ?? []
    }
    
    func fetchManagedObject<T: NSManagedObject>(withIdentifier identifier: Int, includeSubentities: Bool = true, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> T? {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        fetchRequest.predicate = NSPredicate(format: "id == \(identifier)")
        fetchRequest.includesSubentities = includeSubentities
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchLimit = 1
        
        return try? context.fetch(fetchRequest).first
    }
    
    func deleteObject<T: NSManagedObject>(_ object: T) {
        context.delete(object)
    }
    
    func deleteObject(withIdentifier identifier: Int) {
        guard let managedObject = fetchManagedObject(withIdentifier: identifier, includeSubentities: false) else {
            print("Object with identifier \(identifier) does not exist. Nothing to delete.")
            return
        }
        
        deleteObject(managedObject)
    }
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

private extension CoreDataController {
    func managedObjectId(with identifier: String) -> NSManagedObjectID? {
        guard let url = URL(string: identifier) else { return nil }
        
        return context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url)
    }
}
