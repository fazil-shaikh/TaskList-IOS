//
//  TaskTableViewController.swift
//  TaskList
//
//  Created by Fazil Shaikh on 2/14/20.
//  Copyright © 2020 Fazil Shaikh. All rights reserved.
//

import UIKit
import os.log

class TaskTableViewController: UITableViewController {

    //MARK: Properties
     
    var tasks = [Task]()
    
  override func viewDidLoad() {
        super.viewDidLoad()
        
            // Load the sample data.
            loadSampleTasks()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tasks.count
    }
 
    //MARK: Private Methods
  
    // sorts the tabel by date then by completion status
    private func sortRows () {                                                                         
        tasks.sort {$0.date.compare($1.date) == .orderedAscending}
        tasks.sort {!$0.status && $1.status}
    }
    
 
    //MARK: Actions
    
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let task = sourceViewController.task {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Update an existing task.
                tasks[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                
                // Add a new task.
                let newIndexPath = IndexPath(row: tasks.count, section: 0)
                tasks.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // sort the rows and reload the data
            sortRows()
            tableView.reloadData()
        }
    }
    // creates sample tasks to show up on execution
    private func loadSampleTasks() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        let date1 = formatter.date(from: "01/01/2020")
        let date2 = formatter.date(from: "02/02/2020")
        let date3 = formatter.date(from: "03/03/2020")
        
        guard let task1 = Task(name: "Call mom", status: false, date: date1! , info: "") else {
            fatalError("Unable to instantiate task1")
        }
         
        guard let task2 = Task(name: "Get groceries", status: false, date: date2!, info: "") else {
            fatalError("Unable to instantiate task2")
        }
         
        guard let task3 = Task(name: "Do homework", status: false, date: date3!, info: "") else {
            fatalError("Unable to instantiate task3")
        }
           
        tasks += [task1, task2, task3]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TaskTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
        for: indexPath) as? TaskTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TaskTableViewCell.")
        }
        
        // Fetches the appropriate task for the data source layout.
        let task = tasks[indexPath.row]

        // sets the name of the cell lable to the name of the task
        cell.nameLabel?.text = task.name
        
        // sets the date of task on the cell to its proper date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        cell.dateLabel?.text = formatter.string(from: task.date)

        // if the status is complete then change the color to light gray
        // otherwise keep it white
        if task.status == true {
            cell.backgroundColor = UIColor.lightGray
        }else{
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // creates swipe functionality to edit the status of a task or delete it
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let edit = UIContextualAction(
            style: .normal,
            title: self.tasks[indexPath.row].status == false ? "Done" : "Not Done") { (trailingAction, view, actionPerformed: (Bool) -> ()) in
                
            // change the status of the task to opposite status
            self.tasks[indexPath.row].status = !self.tasks[indexPath.row].status
            self.sortRows()
            tableView.reloadData()
            actionPerformed(true)
        }
        edit.backgroundColor = UIColor.green
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (trailingAction, view, actionPerformed: (Bool) -> ()) in
            
            //Delete the row from the data source
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            actionPerformed(true)
        }
        delete.backgroundColor = UIColor.red

     return UISwipeActionsConfiguration(actions: [edit, delete])
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
            case "AddItem":
            os_log("Adding a new task.", log: OSLog.default, type: .debug)
            
            case "ShowDetail":
            guard let taskDetailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
             
            guard let selectedTaskCell = sender as? TaskTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
             
            guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
             
            let selectedTask = tasks[indexPath.row]
            taskDetailViewController.task = selectedTask
            
            default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    

}
