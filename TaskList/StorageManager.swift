//
//  StorageManager.swift
//  TaskList
//
//  Created by Denis Bokov on 05.08.2024.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

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
    
    func save(title titelName: String) {
        let task = Task(context: persistentContainer.viewContext)
        task.title = titelName
        
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }     
      
    }
    
    func fetch() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error  {
            print(error.localizedDescription)
        }
        return []
    }
    
    func delete(to task: Task) {
        let deleteRequest = persistentContainer.viewContext
        deleteRequest.delete(task)
        saveContext()
    }
    
    private init() {}
}
