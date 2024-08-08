//
//  TaskListViewController.swift
//  TaskList
//
//  Created by Denis Bokov on 01.08.2024.
//

import UIKit

//protocol TaskViewControllerDelegate {
//    func reloadData()
//}

class TaskListViewController: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let callID = "task"
    private var taskList: [Task] = []
    private var filtredTasks: [Task] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(
            red: 253/255,
            green: 228/255,
            blue: 196/255,
            alpha: 1
        )
        
        setupSearchController()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: callID)
        
        setupNavigationBar()
        
        fecthData()
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearans =  UINavigationBarAppearance()
        navBarAppearans.backgroundColor = UIColor(
            red: 166/255,
            green: 123/255,
            blue: 91/255,
            alpha: 1
        )
        
        navBarAppearans.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearans.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearans
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearans
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
//        let taskVC = TaskViewController()
//        taskVC.delegate = self
//        present(taskVC, animated: true)
        
        showAlertForAddTask(withTitle: "New Task", andMessage: "What do you want to do?")
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fecthData() {
        StorageManager.shared.fetch { result in
            switch result {
            case .success(let task):
                self.taskList = task
            case .failure(let error):
                print("ERROR: ", error.localizedDescription)
            }
        }
    }
    
    private func addTask(taskName: String) {
        StorageManager.shared.create(for: taskName) { task in
            taskList.append(task)
            tableView.insertRows(
                at: [IndexPath(row: taskList.count - 1, section: 0)],
                with: .automatic
            )
        }
    }
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return isFiltering ? filtredTasks.count : taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: callID, for: indexPath)
        var task: Task
        
        task = isFiltering ? filtredTasks[indexPath.row] : taskList[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    /// Реализация update задачи
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = taskList[indexPath.row]
        
        showAlertForUpdateTask(withTitle: "Update", andMessage: "Do you want to change?", for: task)
    }
    
    /// Реализация удаления задачи
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] action, view, completionHandler in
            let taskToRemove = taskList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            StorageManager.shared.delete(to: taskToRemove)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension TaskListViewController {
    private func showAlertForAddTask(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            addTask(taskName: task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        
        present(alert, animated: true)
    }
    
    private func showAlertForUpdateTask(withTitle title: String, andMessage message: String,for task: Task) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let taskName = alert.textFields?.first?.text, !taskName.isEmpty else { return }
            StorageManager.shared.update(for: task, and: taskName)
            tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.text = task.title
        }
        
        present(alert, animated: true)
    }
}

//extension TaskListViewController: TaskViewControllerDelegate {
//    func reloadData() {
//        taskList = StorageManager.shared.fetch()
//        tableView.reloadData()
//    }
//}

extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filtredTasks = taskList.filter({ task in
            task.title!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
