//
//  CoreDataStorage.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import CoreData

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

final class CoreDataStorage {

    static let shared = CoreDataStorage()
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataStorage")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext(completion: (Bool) -> Void) {
        if context.hasChanges {
            do {
                try context.save()
                completion(true)
            } catch {
                printIfDebug("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
                completion(false)
                // TODO: - Log to Crashlytics
//                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    
    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]?{
        do {
            guard let result = try CoreDataStorage.shared.context.fetch(managedObject.fetchRequest()) as? [T] else {return nil}
            return result

        } catch let error {
            debugPrint(error)
        }

        return nil
    }

}
