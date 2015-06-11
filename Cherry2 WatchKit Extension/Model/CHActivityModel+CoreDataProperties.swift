//
//  CHActivityModel+CoreDataProperties.swift
//  Cherry2
//
//  Created by Kenny Tang on 6/10/15.
//  Copyright © 2015 Kenny Tang. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension CHActivityModel {

    @NSManaged var activityID: String?
    @NSManaged var categoryID: String?
    @NSManaged var createdTime: NSDate?
    @NSManaged var name: String?
    @NSManaged var plannedPomos: NSNumber?
    @NSManaged var actualPomos: NSNumber?

}
