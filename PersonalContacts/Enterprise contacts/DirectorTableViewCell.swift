//
//  DirectionTableViewCell.swift
//  Enterprise contacts
//
//  Created by andrey on 3/2/16.
//  Copyright © 2016 Andrey. All rights reserved.
//

import UIKit


class DirectorTableViewCell: UITableViewCell {

    var director: Director?
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var businessHoursLabel: UILabel!
    
    func configureWithDirector(director: Director) {
        self.director = director
        firstNameLabel.text = director.firstName
        lastNameLabel.text = director.lastName
        guard let salary = director.salary else {return}
        salaryLabel.text = "\(salary)"
        
        guard let startDate = director.businessHoursStart, endDate = director.businessHoursEnd else {return}
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        businessHoursLabel.text = "\(formatter.stringFromDate(startDate)) - \(formatter.stringFromDate(endDate))"
    }
}
