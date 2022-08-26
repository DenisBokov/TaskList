//
//  TaskListViewController.swift
//  TaskList
//
//  Created by Denis Bokov on 22.08.2022.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    private let cellID = "task"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .cyan
        setupNavigationBar()
        fetchData()
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navBarApperance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showAlert(withTitle: "New Task", andMassage: "What do you want to do?")
    }
    
    private func showAlert(withTitle titel: String, andMassage message: String) {
        let alert = UIAlertController(title: titel, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            save(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textFild in
            textFild.placeholder = "New Task"
        }
        
        present(alert, animated: true)
    }
    
    private func fetchData() {
        StoregeMagager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let tasks):
                taskList = tasks
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func save(_ taskName: String) {
        StoregeMagager.shared.create(taskName) { task in
            taskList.append(task)
            let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
            tableView.insertRows(at: [cellIndex], with: .automatic)
        }
    }
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deliteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            StoregeMagager.shared.delete(taskList.remove(at: indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deliteAction])
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let task = taskList[indexPath.row]
//        showAlertUpdate(withTitle: "edit", andMassage: "Edit", task.title ?? "")
//    }
}

