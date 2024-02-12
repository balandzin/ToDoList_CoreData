//
//  NewTaskViewController.swift
//  ToDoList_CoreData
//
//  Created by Антон Баландин on 12.02.24.
//

import UIKit

final class NewTaskViewController: UIViewController {
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        var attributedTitle = AttributeContainer()
        attributedTitle.font = UIFont.boldSystemFont(ofSize: 18)
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "Save Task"
        buttonConfig.baseBackgroundColor = .milkBlue
        buttonConfig.attributedTitle = AttributedString("Save Task", attributes: attributedTitle)
        
        let button = UIButton(configuration: buttonConfig, primaryAction: UIAction { [unowned self] _ in
                save()
        })
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        var attributedTitle = AttributeContainer()
        attributedTitle.font = UIFont.boldSystemFont(ofSize: 18)
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "Save Task"
        buttonConfig.baseBackgroundColor = .milkRed
        buttonConfig.attributedTitle = AttributedString("Cancel", attributes: attributedTitle)
        
        let button = UIButton(configuration: buttonConfig, primaryAction: UIAction { [unowned self] _ in
                dismiss(animated: true)
        })
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupSubviews(taskTextField, saveButton, cancelButton)
        setupConstraints()
    }
    
    private func save() {
        dismiss(animated: true)
    }
}

private extension NewTaskViewController {
     func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    func setupConstraints() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                taskTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
                taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                
                saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
                saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                
                cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
                cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            ])
    }
}

#Preview {
    NewTaskViewController()
}
