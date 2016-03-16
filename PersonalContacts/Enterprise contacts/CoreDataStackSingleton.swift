//
//  CoreDataStackSingleton.swift
//  Enterprise contacts
//
//  Created by andrey on 3/3/16.
//  Copyright © 2016 Andrey. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataValues {
    static let directorEntity = "Director"
    static let employeeEntity = "Employee"
    static let bookkeeperEntity = "Bookkeeper"
    static let firstNameKey = "firstName"
}

class CoreDataStackSingleton {
    static let sharedInstance = CoreDataStackSingleton()
    var coreDataStack: CoreDataStack?
    
    func createDirector() -> Director? {
        if let stack = coreDataStack, entity = NSEntityDescription.entityForName(CoreDataValues.directorEntity, inManagedObjectContext: stack.mainQueueContext) {
            let director =  NSManagedObject(entity: entity, insertIntoManagedObjectContext: nil) as? Director
            director?.workerType = NSNumber(integer: PersonType.director.rawValue)
            director?.firstName = ""
            director?.lastName = ""
            director?.salary = 0
            director?.businessHoursStart = NSDate()
            director?.businessHoursEnd = NSDate()
            return director
        } else {
            return nil
        }
    }
    
    func createEmployee() -> Employee? {
        if let stack = coreDataStack, entity = NSEntityDescription.entityForName(CoreDataValues.employeeEntity, inManagedObjectContext: stack.mainQueueContext) {
            let employee = NSManagedObject(entity: entity, insertIntoManagedObjectContext: nil) as? Employee
            employee?.workerType = NSNumber(integer: PersonType.employee.rawValue)
            employee?.firstName = ""
            employee?.lastName = ""
            employee?.salary = 0
            employee?.lunchTimeStart = NSDate()
            employee?.lunchTimeEnd = NSDate()
            employee?.workplaceNumber = 1
            return employee
        } else {
            return nil
        }
    }
    
    func createBookkeeper() -> Bookkeeper? {
        if let stack = coreDataStack, entity = NSEntityDescription.entityForName(CoreDataValues.bookkeeperEntity, inManagedObjectContext: stack.mainQueueContext) {
            let bookkeeper = NSManagedObject(entity: entity, insertIntoManagedObjectContext: nil) as? Bookkeeper
            bookkeeper?.workerType = NSNumber(integer: PersonType.bookkeeper.rawValue)
            bookkeeper?.firstName = ""
            bookkeeper?.lastName = ""
            bookkeeper?.salary = 0
            bookkeeper?.lunchTimeStart = NSDate()
            bookkeeper?.lunchTimeEnd = NSDate()
            bookkeeper?.workplaceNumber = 1
            bookkeeper?.type = 0
            return bookkeeper
        } else {
            return nil
        }
    }
    
    func saveContext() {
        do {
           try coreDataStack?.mainQueueContext.save()
        } catch let error as NSError {
            print("error: \(error), \(error.userInfo) ")
        }
    }
}

