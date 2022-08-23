//
//  TaskViewController.swift
//  TaskList
//
//  Created by Denis Bokov on 22.08.2022.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    var delegate: TaskViewControllerDelegate!
    
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private lazy var taskTextFild: UITextField = {
        let textFild = UITextField()
        textFild.borderStyle = .roundedRect
        textFild.placeholder = "New Task"
        return textFild
    }()
    
    private lazy var saveButton: UIButton = {
        setupButton(
            with: "Save Task",
            and: UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 194/255),
            action: UIAction { [unowned self] _ in
                save()
            }
        )
    }()
    
    private lazy var cancelButton: UIButton = {
        setupButton(
            with: "Cancel",
            and: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),
            action: UIAction { [unowned self] _ in
                dismiss(animated: true)
            }
        )
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupSubviews(taskTextFild, saveButton, cancelButton)
        setConstraints()
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupButton(with titel: String, and colorButton: UIColor, action: UIAction) -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.attributedTitle = AttributedString(titel, attributes: attributes)
        buttonConfiguration.baseBackgroundColor = colorButton
        return UIButton(configuration: buttonConfiguration, primaryAction: action)
    }
    
    private func setConstraints() {
        taskTextFild.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextFild.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextFild.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextFild.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextFild.bottomAnchor, constant: 50),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 50),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
    }
    
    private func save() {
        let task = Task(context: viewContext)
        task.title = taskTextFild.text
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        delegate.reloadData()
        dismiss(animated: true)
    }
}
