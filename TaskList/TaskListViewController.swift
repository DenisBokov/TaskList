//
//  TaskListViewController.swift
//  TaskList
//
//  Created by Denis Bokov on 01.08.2024.
//

import UIKit

protocol TaskViewControllerDelegate {
    func reloadData()
}

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
        taskList = StorageManager.shared.fetch()
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
        
        showAlert(withTitle: "New Task", andMessage: "What do you want to do?")
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            StorageManager.shared.save(title: task)
            tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        
        present(alert, animated: true)
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] action, view, completionHandler in
            let taskToRemove = taskList[indexPath.row]
            
            StorageManager.shared.delete(to: taskToRemove)
            
//            StorageManager.shared.save(title: <#String#>)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension TaskListViewController: TaskViewControllerDelegate {
    func reloadData() {
        taskList = StorageManager.shared.fetch()
        tableView.reloadData()
    }
}

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
