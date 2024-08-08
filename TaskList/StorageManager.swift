//
//  StorageManager.swift
//  TaskList
//
//  Created by Denis Bokov on 05.08.2024.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving

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
    
    // MARK: - Core Data Create
    
    func create(for taskName: String, complition: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = taskName
        complition(task)
        saveContext()
    }
    
    // MARK: - Core Data fechData
    
    func fetch(complition: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let task = try viewContext.fetch(fetchRequest)
            complition(.success(task))
        } catch let error  {
            complition(.failure(error))
        }
    }
    
    // MARK: - Core Data Update
    
    func update(for task: Task, and name: String) {
        task.title = name
        saveContext()
    }
    
    // MARK: - Core Data Delete
    
    func delete(to task: Task) {
        viewContext.delete(task)
        saveContext()
    }
}
