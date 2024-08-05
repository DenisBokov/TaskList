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
    
    private let callID = "task"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(
            red: 253/255,
            green: 228/255,
            blue: 196/255,
            alpha: 1
        )
        
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
        let taskVC = TaskViewController()
        taskVC.delegate = self
        present(taskVC, animated: true)
    }
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: callID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
}

extension TaskListViewController: TaskViewControllerDelegate {
    func reloadData() {
        taskList = StorageManager.shared.fetch()
        tableView.reloadData()
    }
}
