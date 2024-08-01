//
//  TaskViewController.swift
//  TaskList
//
//  Created by Denis Bokov on 01.08.2024.
//

import UIKit

class TaskViewController: UIViewController {
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "New Task"
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.title = "Save Task"
        buttonConfiguration.baseBackgroundColor = UIColor(
            red: 166/255,
            green: 123/255,
            blue: 91/255,
            alpha: 1
        )
        return UIButton(configuration: buttonConfiguration, primaryAction: UIAction { [ unowned self ] _ in
            dismiss(animated: true)
        })
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(
            red: 253/255,
            green: 228/255,
            blue: 196/255,
            alpha: 1
        )
        
        setrupSabviews(taskTextField, saveButton)
        setupConstraints()
    }
    
    private func setrupSabviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupConstraints() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

    }

}
