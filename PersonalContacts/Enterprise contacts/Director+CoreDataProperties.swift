//
//  Direction+CoreDataProperties.swift
//  Enterprise contacts
//
//  Created by andrey on 3/2/16.
//  Copyright © 2016 Andrey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Director {
    @NSManaged var businessHoursStart: NSDate?
    @NSManaged var businessHoursEnd: NSDate?
}
