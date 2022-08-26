//
//  StoregeMagager.swift
//  TaskList
//
//  Created by Denis Bokov on 23.08.2022.
//

import Foundation
import CoreData


class StoregeMagager {
    static let shared = StoregeMagager()
    
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
    
    private let viewContext: NSManagedObjectContext // объявление контеста
    
    private init() {
        viewContext = persistentContainer.viewContext
    }

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
    
    func create(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext) // оздаем объект модели
        task.title = taskName
        completion(task)
        saveContext()
    }
    
    func update(_ task: Task, newName: String) {
        task.title = newName
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    func fetchData(сompletion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest() // создаем запрос в базу данных
        
        do {
            let task = try viewContext.fetch(fetchRequest)
            сompletion(.success(task))
        } catch let error {
            сompletion(.failure(error))
        }
    }
}
