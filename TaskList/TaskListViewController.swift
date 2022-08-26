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
        showAlert()
    }
    
    private func fetchData() { // загрузка данных
        StoregeMagager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let tasks):
                taskList = tasks // обновляем массив задач в таблице из базы и отображаем их
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func save(_ taskName: String) {
        StoregeMagager.shared.create(taskName) { task in // возврат созданной Задачи объекта
            taskList.append(task)
            let cellIndex = IndexPath(row: taskList.count - 1, section: 0) // получаем индекс строки
            tableView.insertRows(at: [cellIndex], with: .automatic) // добавляем в таблицу
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // снимаю выделение с ячейки
        let task = taskList[indexPath.row]
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension TaskListViewController {
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        let titel = task != nil ? "Update Task" : "New Task"
        let alert = UIAlertController.createAlertController(withTitle: titel)
        
        alert.action(task: task) { [weak self] taskName in
            if let task = task, let completion = completion {
                StoregeMagager.shared.update(task, newName: taskName)
                completion()
            } else {
                self?.save(taskName)
            }
        }
        
        present(alert, animated: true)
    }
}

extension UIAlertController {
    static func createAlertController(withTitle title: String) -> UIAlertController {
        UIAlertController(title: title, message: "What do you want to do?", preferredStyle: .alert)
    }
    
    func action(task: Task?, completion: @escaping(String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let newValue = self?.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "Task"
            textField.text = task?.title
        }
    }
}
