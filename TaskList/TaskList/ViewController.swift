//
//  ViewController.swift
//  TaskList
//
//  Created by Fazil Shaikh on 2/13/20.
//  Copyright © 2020 Fazil Shaikh. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var statusButton: UISwitch!
    @IBOutlet weak var addDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var infoTextField: UITextField!
    
    /*
     This value is either passed by `TaskTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new task.
     */
    
    var task: Task?
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hanndle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        infoTextField.delegate = self
        
        // sets up views if editing an existing Task.
        if let task = task {
            navigationItem.title = task.name
            nameTextField.text = task.name
            statusButton.isOn = task.status
            date = task.date
            infoTextField.text = task.info
            
            // sets the datepicker to saved date
            datePicker.date = task.date
            
            // changes the button title to the selected date
            addDateButton.setTitle(formatDate(tempDate: date), for:.normal)
        }
        
        // enable the Save button only if the text field has a valid Task name.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = nameTextField.text
    }
    
    //MARK: Date Picker
    
    // the button that allows user to select due dates for the task
    @IBAction func addDateButton(_ sender: UIButton) {
        // enable the date picker functionality to the user when the button is pressed
        if self.datePicker.isHidden {
           self.datePicker.isHidden = false
           self.addDateButton.setTitle("Choose Date", for:.normal)
            
        } else {
            self.datePicker.isHidden = true
            self.date = self.datePicker.date
            
            // changes the button title to the selected date
            self.addDateButton.setTitle(self.formatDate(tempDate: self.date), for:.normal)
            }
    }
    
    //MARK: Navigation
    
    // button to cancel out of the edit/create a task screen
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        
        if isPresentingInAddTaskMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let status = statusButton.isOn
        let date = self.date
        let info = infoTextField.text ?? ""
        
        // Set the task to be passed to TaskTableViewController after the unwind segue.
        task = Task(name: name, status: status, date: date, info: info)
    }
    
    //MARK: Private Methods
    
    // function to enable save functionality
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    // function to format dates into String
    private func formatDate(tempDate : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from:tempDate)
    }
}
