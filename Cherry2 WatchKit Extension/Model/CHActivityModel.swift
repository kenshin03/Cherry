//
//  CHActivityModel.swift
//  Cherry2
//
//  Created by Kenny Tang on 6/10/15.
//  Copyright © 2015 Kenny Tang. All rights reserved.
//

import Foundation
import CoreData

@objc(CHActivityModel)
public class CHActivityModel: NSManagedObject {

    @NSManaged var activityID: String?
    @NSManaged var categoryID: String?
    @NSManaged var createdTime: NSDate?
    @NSManaged var name: String?
    @NSManaged var plannedPomos: NSNumber?
    @NSManaged var actualPomos: NSNumber?

}
