//
//  EmployeeTableViewCell.swift
//  Enterprise contacts
//
//  Created by andrey on 3/2/16.
//  Copyright © 2016 Andrey. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    var employee: Employee?
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var lunchTimeLabel: UILabel!
    @IBOutlet weak var workplaceNumberLabel: UILabel!
    
    func configureWithEmployee(employee: Employee) {
        self.employee = employee
        firstNameLabel.text = employee.firstName
        lastNameLabel.text = employee.lastName
        guard let salary = employee.salary else {return}
        salaryLabel.text = "\(salary)"
        
        guard let startDate = employee.lunchTimeStart, endDate = employee.lunchTimeEnd else {return}
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        lunchTimeLabel.text = "\(formatter.stringFromDate(startDate)) - \(formatter.stringFromDate(endDate))"
        
        guard let placeNumber = employee.workplaceNumber else {return}
        workplaceNumberLabel.text = "\(placeNumber)"
    }
}
