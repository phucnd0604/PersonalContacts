//
//  BookkeepingTableViewCell.swift
//  Enterprise contacts
//
//  Created by andrey on 3/2/16.
//  Copyright © 2016 Andrey. All rights reserved.
//

import UIKit

class BookkeeperTableViewCell: UITableViewCell {

    var bookkeeper: Bookkeeper?
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var lunchTimeLabel: UILabel!
    @IBOutlet weak var workplaceNumberLabel: UILabel!
    @IBOutlet weak var bookkeeperTypeLabel: UILabel!
    
    func configureWithBookkeeper(bookkeeper: Bookkeeper) {
        self.bookkeeper = bookkeeper
        firstNameLabel.text = bookkeeper.firstName
        lastNameLabel.text = bookkeeper.lastName
        guard let salary = bookkeeper.salary else {return}
        salaryLabel.text = "\(salary)"
        
        guard let startDate = bookkeeper.lunchTimeStart, endDate = bookkeeper.lunchTimeEnd else {return}
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        lunchTimeLabel.text = "\(formatter.stringFromDate(startDate)) - \(formatter.stringFromDate(endDate))"
        
        guard let placeNumber = bookkeeper.workplaceNumber else {return}
        workplaceNumberLabel.text = "\(placeNumber)"
        
        if bookkeeper.type == 0 {
            bookkeeperTypeLabel.text = "Calculation"
        } else {
            bookkeeperTypeLabel.text = "Accounting"
        }
    }
}
