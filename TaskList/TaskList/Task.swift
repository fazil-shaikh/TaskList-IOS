//
//  Task.swift
//  TaskList
//
//  Created by Fazil Shaikh on 2/13/20.
//  Copyright © 2020 Fazil Shaikh. All rights reserved.
//

import UIKit

class Task{
    
    //MARK: Types
    
    var name: String
    var status: Bool
    var date: Date
    var info: String
    
    //MARK: Initialization
    
    init?(name: String, status: Bool, date: Date, info: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.status = status
        self.date = date
        self.info = info
    }
}

