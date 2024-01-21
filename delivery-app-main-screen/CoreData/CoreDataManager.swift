//
//  CoreDataHelper.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 20.01.2024.
//

import CoreData

enum CoreDataEntity: String {
    case MenuItemsResponse = "MenuItemsResponse"
    case MenuItem = "MenuItem"
    case Servings = "Servings"
}

class CoreDataManager {
            
    lazy var container: NSPersistentContainer = {
        let persistenceContainer = NSPersistentContainer(name: "DataModel")
        persistenceContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Persistence Container Failure: \(error)")
            }
        })
        return persistenceContainer
    }()
    
    var context: NSManagedObjectContext { return container.viewContext }
    
    static let shared = CoreDataManager()

    
    private init() {}
    
    // MARK: - CRUD Operations
    
    func create<T: NSManagedObject>(entityType: T.Type) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: entityType), into: context) as? T
    }
    
    func delete<T: NSManagedObject>(_ entity: T) {
        context.delete(entity)
        saveContext()
    }
    
    func deleteAll(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let entities = try context.fetch(fetchRequest) as? [NSManagedObject]
            entities?.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error while deleting all \(entityName) entities: \(error.localizedDescription)")
        }
    }
    
    func update<T: NSManagedObject>(entity: T) {
        saveContext()
    }
    
    // MARK: - Fetching
    
    func fetch<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, rowLimit: Int? = nil) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: entityType))
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        request.sortDescriptors = sortDescriptors
        if let rowLimit = rowLimit {
            request.fetchLimit = rowLimit
        }
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error while fetching \(String(describing: entityType)) entities: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetch<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, rowLimit: Int? = nil, completion: @escaping (Result<[T], Error>) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: entityType))
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        request.sortDescriptors = sortDescriptors
        if let rowLimit = rowLimit {
            request.fetchLimit = rowLimit
        }
        
        do {
            let result = try context.fetch(request)
            completion(.success(result))
        } catch {
            print("Error while fetching \(String(describing: entityType)) entities: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    // MARK: - Relationship Management
    
    func add(_ relatedObject: NSManagedObject, to entity: NSManagedObject, forKey key: String) {
        entity.setValue(relatedObject, forKey: key)
        saveContext()
    }
    
    // MARK: - Error Handling
    
    func handle(_ error: Error) {
        print("Core Data Error: \(error.localizedDescription)")
    }
    
    // MARK: - Saving
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                handle(error)
            }
        }
    }
}
