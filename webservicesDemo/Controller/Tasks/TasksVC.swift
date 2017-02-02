//
//  TasksVC.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 2/2/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import UIKit


class TasksVC: UIViewController {
    
    fileprivate let cellIdentifier = "TaskCell"
    fileprivate let cellHeight: CGFloat = 60.0
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks = [Task]()
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        return refresher
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Tasks"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationItem.rightBarButtonItem = addButton
        
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.contentInset = .zero
        
        tableView.addSubview(refresher)
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        handleRefresh()
    }
    
    @objc private func handleAdd() {
        
        let alert = UIAlertController(title: "Add New Task", message: "enter title", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: {
            $0.placeholder = "Title"
            $0.textAlignment = .center
        })
        
        alert.addAction(UIAlertAction(title: "ADD", style: .destructive, handler: { (action: UIAlertAction) in
            guard let title = alert.textFields?.first?.text?.trimmed, !title.isEmpty else { return }
            
            // send new task to server
            self.sendNewTaskToServer(title: title)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func sendNewTaskToServer(title: String) {
        // api code
        print("Send title \(title) to API")
        
        let newTask = Task(title: title)
        
        API.newTask(newTask: newTask) { (error: Error?, task: Task?) in
            if let task = task {
                // add it to model
                self.tasks.insert(task, at: 0)
                
                // insert new row in tableview
                
//                self.tableView.reloadData()
                self.tableView.beginUpdates()
                
                self.tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                
                self.tableView.endUpdates()
            }
        }
    }
    
    var isLoading: Bool = false
    var current_page = 1
    var last_page = 1
    
    @objc fileprivate func handleRefresh() {
        self.refresher.endRefreshing()
        guard !isLoading else { return }
        
        isLoading = true
        API.tasks { (error: Error?, tasks: [Task]?, last_page: Int) in
            self.isLoading = false
            if let tasks = tasks {
                self.tasks = tasks
                self.tableView.reloadData()
                
                self.current_page = 1
                self.last_page = last_page
            }
        }
        
    }
    
    fileprivate func loadMore() {
        guard !isLoading else { return }
        guard current_page < last_page else { return }
        
        isLoading = true
        API.tasks(page: current_page+1) { (error: Error?, tasks: [Task]?, last_page: Int) in
            self.isLoading = false
            if let tasks = tasks {
                self.tasks.append(contentsOf: tasks)
                self.tableView.reloadData()
                
                self.current_page += 1
                self.last_page = last_page
            }
        }
    }

}


extension TasksVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        
        let task = tasks[indexPath.row]
        cell.configureCell(task: task)
        
        return cell
    }
    
}


extension TasksVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.tasks.count
        
        if indexPath.row == count-1 {
            // last row
            self.loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = tasks[indexPath.row]
        
        let editedTask = task.copy() as! Task
        editedTask.completed = !editedTask.completed
        
        API.editTask(task: editedTask) { (error: Error?, finalTask: Task?) in
            if let finalTask = finalTask {
                // replace task with editedTask
                if let index = self.tasks.index(of: task) {
                    
                    self.tasks.remove(at: index)
                    self.tasks.insert(finalTask, at: index)
                    
                    // refresh row
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                    
                } else {
                    
                    self.handleRefresh()
                    
                }
                
            } else {
                // show alert to user to try again
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let task = tasks[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action: UITableViewRowAction, indexPath: IndexPath) in
            
            self.handleDelete(task: task, indexPath: indexPath)
            
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action: UITableViewRowAction, indexPath: IndexPath) in
            
            self.handleEdit(task: task, indexPath: indexPath)
            
        }
        editAction.backgroundColor = .lightGray
        
        return [deleteAction, editAction]
    }
    
    
    private func handleDelete(task: Task, indexPath: IndexPath) {
        
        API.deleteTask(task: task) { (error: Error?, success: Bool) in
            if success {
               
                if let index = self.tasks.index(of: task) {
                    self.tasks.remove(at: index)
                    
                    // remove row
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                } else {
                    self.tableView.reloadData()
                }
                
            } else {
                // show alert to user to try again
            }
        }
        
    }
    
    
    private func handleEdit(task: Task, indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Edit Task", message: "enter title", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: {
            $0.text = task.task
            $0.placeholder = "Title"
            $0.textAlignment = .center
        })
        
        alert.addAction(UIAlertAction(title: "EDIT", style: .destructive, handler: { (action: UIAlertAction) in
            guard let title = alert.textFields?.first?.text?.trimmed, !title.isEmpty else { return }
            
            // send new task title to server
            let editTask = task.copy() as! Task
            editTask.task = title
            
            API.editTask(task: editTask, completion: { (error: Error?, editedTask: Task?) in
                if let editedTask = editedTask {
                    // replace task with editedTask
                    if let index = self.tasks.index(of: task) {
                        
                        self.tasks.remove(at: index)
                        self.tasks.insert(editedTask, at: index)
                        
                        // refresh row
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        self.tableView.endUpdates()
                        
                    } else {
                        
                        self.handleRefresh()
                        
                    }
                    
                } else {
                    // show alert to user to try again
                }
            })
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

















