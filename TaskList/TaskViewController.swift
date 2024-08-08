//
//  TaskViewController.swift
//  TaskList
//
//  Created by Denis Bokov on 01.08.2024.
//

import UIKit

class TaskViewController: UIViewController {
    
//    var delegate: TaskViewControllerDelegate!
    
    private let storageManager = StorageManager.shared
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "New Task"
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        setupButtons(
            "Save Task",
            colorButton: UIColor(red: 166/255, green: 123/255, blue: 91/255, alpha: 1),
            action: UIAction { [unowned self] _ in
                storageManager.save(title: taskTextField.text ?? "")
//                delegate.reloadData()
                dismiss(animated: true)
            }
        )
    }()
    
    private lazy var cancelButton: UIButton = {
        setupButtons(
            "Cancel",
            colorButton: UIColor(red: 183/255, green: 65/255, blue: 14/255, alpha: 1),
            action: UIAction { [unowned self] _ in
                dismiss(animated: true)
            }
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(
            red: 253/255,
            green: 228/255,
            blue: 196/255,
            alpha: 1
        )
        
        setrupSabviews(taskTextField, saveButton, cancelButton)
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
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 40),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

    }
    
    private func setupButtons(_ buttonName: String, colorButton: UIColor, action: UIAction) -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.attributedTitle = AttributedString(buttonName, attributes: attributes)
        buttonConfiguration.baseBackgroundColor = colorButton
        return UIButton(configuration: buttonConfiguration, primaryAction: action)
    }
}
