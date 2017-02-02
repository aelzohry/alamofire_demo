//
//  TaskCell.swift
//  webservicesDemo
//
//  Created by Ahmed Elzohry on 2/2/17.
//  Copyright © 2017 Ahmed Elzohry. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func configureCell(task: Task) {
        textLabel?.text = task.task
        backgroundColor = task.completed ? .yellow : .clear
        
        /*if task.completed {
         cell.backgroundColor = .yellow
         } else {
         cell.backgroundColor = .clear
         }*/
    }

}
