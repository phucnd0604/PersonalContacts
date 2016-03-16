//
//  WorkerViewController.swift
//  Enterprise contacts
//
//  Created by andrey on 3/2/16.
//  Copyright © 2016 Andrey. All rights reserved.
//

import UIKit
enum PersonType: Int {
    case director, employee, bookkeeper
}
class WorkerTableViewController: FormViewController {
    var adding = false
    var director: Director?
    var employee: Employee?
    var bookkeeper: Bookkeeper?
    var initialPersonType: PersonType?
    private var currentPersonType: PersonType?
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "back")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save")
        self.navigationItem.title = "Worker"
        
        if adding {
            director = CoreDataStackSingleton.sharedInstance.createDirector()
            employee = CoreDataStackSingleton.sharedInstance.createEmployee()
            bookkeeper = CoreDataStackSingleton.sharedInstance.createBookkeeper()
            currentPersonType = .employee
        } else {
            currentPersonType = initialPersonType
            if let workerType = currentPersonType {
                switch workerType {
                case .director:
                    employee = CoreDataStackSingleton.sharedInstance.createEmployee()
                    bookkeeper = CoreDataStackSingleton.sharedInstance.createBookkeeper()
                case .employee:
                    director = CoreDataStackSingleton.sharedInstance.createDirector()
                    bookkeeper = CoreDataStackSingleton.sharedInstance.createBookkeeper()
                case .bookkeeper:
                    director = CoreDataStackSingleton.sharedInstance.createDirector()
                    employee = CoreDataStackSingleton.sharedInstance.createEmployee()
                }
            }
        }
        
        form +++=
            
            Section()
            
            <<< SegmentedRow<String>("person") { [weak self] row in
                row.title = "Person:"
                row.options = ["Director", "Employee", "Bookkeeper"]
                if let workerType = self?.currentPersonType {
                    switch workerType {
                    case .director: row.value = "Director"
                    case .employee: row.value = "Employee"
                    case .bookkeeper: row.value = "Bookkeeper"
                    }
                }
                
            }.onChange { [weak self] row in
                guard let value = row.value else {return}
                switch value {
                case "Director":
                    self?.form.rowByTag("start_time")?.title = "Business hours starts"
                    self?.form.rowByTag("end_time")?.title = "Business hours ends"
                    self?.currentPersonType = .director
                case "Employee":
                    self?.form.rowByTag("start_time")?.title = "Lunch time starts"
                    self?.form.rowByTag("end_time")?.title = "Lunch time ends"
                    self?.currentPersonType = .employee
                case "Bookkeeper":
                    self?.form.rowByTag("start_time")?.title = "Lunch time starts"
                    self?.form.rowByTag("end_time")?.title = "Lunch time ends"
                    self?.currentPersonType = .bookkeeper
                default: break
                }
                self?.form.rowByTag("first_name")?.updateCell()
                self?.form.rowByTag("last_name")?.updateCell()
                self?.form.rowByTag("salary")?.updateCell()
                self?.form.rowByTag("start_time")?.updateCell()
                self?.form.rowByTag("end_time")?.updateCell()
                self?.form.rowByTag("workplace_number")?.updateCell()
                self?.form.rowByTag("bookkeeper_type")?.updateCell()
            }
            
            <<< TextRow("first_name") { [weak self] row in
                row.title = "First Name"
                row.placeholder = "Enter first name here"
                if let workerType = self?.currentPersonType {
                    switch workerType {
                    case .director: row.value = self?.director?.firstName
                    case .employee: row.value = self?.employee?.firstName
                    case .bookkeeper: row.value = self?.bookkeeper?.firstName
                    }
                }
                
            }.onChange { [weak self] row in
                self?.director?.firstName = row.value
                self?.employee?.firstName = row.value
                self?.bookkeeper?.firstName = row.value
            }.cellUpdate { [weak self] cell, row in
                self?.director?.firstName = row.value
                self?.employee?.firstName = row.value
                self?.bookkeeper?.firstName = row.value
            }
            
            <<< TextRow("last_name") { [weak self] row in
                row.title = "Last Name"
                row.placeholder = "Enter last name here"
                if let workerType = self?.currentPersonType {
                    switch workerType {
                    case .director: row.value = self?.director?.lastName
                    case .employee: row.value = self?.employee?.lastName
                    case .bookkeeper: row.value = self?.bookkeeper?.lastName
                    }
                }
                
            }.onChange{ [weak self] row in
                self?.director?.lastName = row.value
                self?.employee?.lastName = row.value
                self?.bookkeeper?.lastName = row.value
            }.cellUpdate{ [weak self] cell, row in
                self?.director?.lastName = row.value
                self?.employee?.lastName = row.value
                self?.bookkeeper?.lastName = row.value
            }
            
            <<< DecimalRow("salary") { [weak self] row in
                row.title = "Salary"
                row.placeholder = "Enter salary here"
                if let workerType = self?.currentPersonType {
                    switch workerType {
                    case .director:
                        if let salary = self?.director?.salary{
                            row.value = Double(salary)
                        }
                    case .employee:
                        if let salary = self?.employee?.salary{
                            row.value = Double(salary)
                        }
                    case .bookkeeper:
                        if let salary = self?.bookkeeper?.salary{
                            row.value = Double(salary)
                        }
                    }
                }
                
            }.onChange{ [weak self] row in
                guard let value = row.value else {return}
                self?.director?.salary = NSDecimalNumber(double: value)
                self?.employee?.salary = NSDecimalNumber(double: value)
                self?.bookkeeper?.salary = NSDecimalNumber(double: value)
            }.cellUpdate { [weak self] cell, row in
                guard let value = row.value else {return}
                self?.director?.salary = NSDecimalNumber(double: value)
                self?.employee?.salary = NSDecimalNumber(double: value)
                self?.bookkeeper?.salary = NSDecimalNumber(double: value)
            }
            
            <<< TimeRow("start_time") { [weak self] row in
                if let workerType = self?.currentPersonType {
                    switch workerType {
                    case .director:
                        row.value = self?.director?.businessHoursStart
                        row.title = "Business hours starts"
                    case .employee:
                        row.value = self?.employee?.lunchTimeStart
                        row.title = "Lunch time starts"
                    case .bookkeeper:
                        row.value = self?.bookkeeper?.lunchTimeStart
                        row.title = "Lunch time starts"
                    }
                }
                
            }.onChange{ [weak self] row in
                self?.director?.businessHoursStart = row.value
                self?.employee?.lunchTimeStart = row.value
                self?.bookkeeper?.lunchTimeStart = row.value
            }.cellUpdate{ [weak self] cell, row in
                self?.director?.businessHoursStart = row.value
                self?.employee?.lunchTimeStart = row.value
                self?.bookkeeper?.lunchTimeStart = row.value
            }
            
            <<< TimeRow("end_time") { [weak self] row in
                if let workerType = self?.currentPersonType {
                    switch workerType {
                    case .director:
                        row.value = self?.director?.businessHoursEnd
                        row.title = "Business hours ends"
                    case .employee:
                        row.value = self?.employee?.lunchTimeEnd
                        row.title = "Lunch time ends"
                    case .bookkeeper:
                        row.value = self?.bookkeeper?.lunchTimeEnd
                        row.title = "Lunch time ends"
                    }
                }
                
            }.onChange{ [weak self] row in
                self?.director?.businessHoursEnd = row.value
                self?.employee?.lunchTimeEnd = row.value
                self?.bookkeeper?.lunchTimeEnd = row.value
            }.cellUpdate{ [weak self] cell, row in
                self?.director?.businessHoursEnd = row.value
                self?.employee?.lunchTimeEnd = row.value
                self?.bookkeeper?.lunchTimeEnd = row.value
            }
            
            <<< IntRow("workplace_number") { [weak self] row in
                row.title = "Workplace number"
                row.hidden = "$person == 'Director'"
                row.placeholder = "Enter the workplace number"
                if let workerType = self?.currentPersonType {
                    switch workerType {
                    case .employee:
                        if let workplaceNumber = self?.employee?.workplaceNumber{
                            row.value = Int(workplaceNumber)
                        }
                    case .bookkeeper:
                        if let workplaceNumber = self?.bookkeeper?.workplaceNumber{
                            row.value = Int(workplaceNumber)
                        }
                    default: break
                    }
                }
                
            }.onChange{ [weak self] row in
                self?.employee?.workplaceNumber = row.value
                self?.bookkeeper?.workplaceNumber = row.value
            }.cellUpdate{ [weak self] cell, row in
                self?.employee?.workplaceNumber = row.value
                self?.bookkeeper?.workplaceNumber = row.value
            }
            
            <<< SegmentedRow<String>("bookkeeper_type"){ [weak self] row in
                row.title = "Bookkeeper type"
                row.options = ["Calculation", "Accounting"]
                row.hidden = "$person != 'Bookkeeper'"
                if let workerType = self?.currentPersonType {
                    if workerType == .bookkeeper {
                        if self?.bookkeeper?.type == 0 {
                            row.value = "Calculation"
                        } else {
                            row.value = "Accounting"
                        }
                    } else {
                        row.value = "Calculation"
                    }
                } else {
                    row.value = "Calculation"
                }
                
            }.onChange{ [weak self] row in
                if row.value == "Calculation" {
                    self?.bookkeeper?.type = 0
                } else {
                    self?.bookkeeper?.type = 1
                }
            }.cellUpdate{ [weak self] cell, row in
                if row.value == "Calculation" {
                    self?.bookkeeper?.type = 0
                } else {
                    self?.bookkeeper?.type = 1
                }
            }
        
        form.rowByTag("first_name")?.updateCell()
        form.rowByTag("last_name")?.updateCell()
        form.rowByTag("salary")?.updateCell()
        form.rowByTag("start_time")?.updateCell()
        form.rowByTag("end_time")?.updateCell()
        form.rowByTag("workplace_number")?.updateCell()
        form.rowByTag("bookkeeper_type")?.updateCell()
    }
    
    //MARK: - Actions
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    func save() {
        if adding {
            if let personType = currentPersonType {
                switch personType {
                case .director:
                    if let directorToInsert = director, stack = CoreDataStackSingleton.sharedInstance.coreDataStack {
                        stack.mainQueueContext.insertObject(directorToInsert)
                    }
                case .employee:
                    if let employeeToInsert = employee, stack = CoreDataStackSingleton.sharedInstance.coreDataStack {
                        stack.mainQueueContext.insertObject(employeeToInsert)
                        print("workerType(employee) = \(employeeToInsert.workerType)")
                    }
                case .bookkeeper:
                    if let bookkeeperToInsert = bookkeeper, stack = CoreDataStackSingleton.sharedInstance.coreDataStack {
                        stack.mainQueueContext.insertObject(bookkeeperToInsert)
                        print("workerType(bookkeeper) = \(bookkeeperToInsert.workerType)")
                    }
                }
            }
        } else {
            if currentPersonType != initialPersonType {
                if let currentType = currentPersonType, initialType = initialPersonType, director = director, employee = employee, bookkeeper = bookkeeper, context = CoreDataStackSingleton.sharedInstance.coreDataStack?.mainQueueContext{
                    switch initialType {
                    case .director: context.deleteObject(director)
                    case .employee: context.deleteObject(employee)
                    case .bookkeeper: context.deleteObject(bookkeeper)
                    }
                    switch currentType {
                    case .director: context.insertObject(director)
                    case .employee: context.insertObject(employee)
                    case .bookkeeper: context.insertObject(bookkeeper)
                    }
                }
            }
        }
        CoreDataStackSingleton.sharedInstance.saveContext()
        back()
    }
}
