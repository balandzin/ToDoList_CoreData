//
//  StorageManager.swift
//  ToDoList_CoreData
//
//  Created by Антон Баландин on 12.02.24.
//

import UIKit
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList_CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var managedContext: NSManagedObjectContext {
            return persistentContainer.viewContext
        }
    
    func saveContext () {
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
    
    func deleteObject(_ object: NSManagedObject) {
            managedContext.delete(object)
            saveContext()
        }
    
    func fetchObjects<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
            let entityName = String(describing: objectType)
            let fetchRequest = NSFetchRequest<T>(entityName: entityName)

            do {
                let fetchedObjects = try managedContext.fetch(fetchRequest)
                return fetchedObjects
            } catch {
                print("Failed to fetch objects: \(error)")
                return []
            }
        }
}
