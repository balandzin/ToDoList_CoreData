//
//  ViewController.swift
//  ToDoList_CoreData
//
//  Created by Антон Баландин on 12.02.24.
//

import UIKit

final class TaskListViewController: UITableViewController {
    private var taskList: [ToDoTask] = []
    private let cellID = "task"
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        
        taskList = storageManager.fetchObjects(ToDoTask.self)
    }
    
    @objc private func addNewTask() {
        showAlert(withTitle: "New Task", andMessage: "What do you want to do", forRowAt: 0)
    }
    
    private func save(_ taskName: String) {
        let task = ToDoTask(context: storageManager.persistentContainer.viewContext)
        task.title = taskName
        taskList.append(task)
        
        let indexPath = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        storageManager.saveContext()
    }
    
    func deleteObject(at indexPath: IndexPath) {
        let objects = storageManager.fetchObjects(ToDoTask.self)
        let object = objects[indexPath.row]
        storageManager.deleteObject(object)
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = taskList[indexPath.row]
            storageManager.deleteTask(taskToDelete)
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(withTitle: "Edit Task", andMessage: "",forRowAt: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let toDoTask = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = toDoTask.title
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - Setup UI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.backgroundColor = .milkBlue
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }
}

private extension TaskListViewController {
    func showAlert(withTitle title: String, andMessage message: String, forRowAt row: Int) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if message != ""  {
            alert.addTextField { textField in
                textField.placeholder = "New Task"
            }
            let saveAction = UIAlertAction(title: "Save Task", style: .default) { [unowned self] _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
                save(task)
            }
            alert.addAction(saveAction)
        } else {
            let taskToEdit = taskList[row]
            alert.addTextField { textField in
                textField.text = taskToEdit.title
            }
            let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
                guard let updateTask = alert.textFields?.first?.text, !updateTask.isEmpty else { return }
                taskToEdit.title = updateTask
                
                let indexPath = IndexPath(row: row, section: 0)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
                storageManager.saveContext()
            }
            alert.addAction(saveAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

