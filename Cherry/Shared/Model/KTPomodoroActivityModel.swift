//
//  KTPomodoroActivityModel.swift
//  Cherry
//
//  Created by Kenny Tang on 2/22/15.
//
//

import Foundation
import CoreData

// Fix for unit test error "swift core data dynamic_Cast Class Unconditional"
// http://stackoverflow.com/a/25106423

@objc(KTPomodoroActivityModel)

public class KTPomodoroActivityModel: NSManagedObject {

    @NSManaged public var activityID: String
    @NSManaged public var actual_pomo: NSNumber
    @NSManaged public var created_time: NSDate
    @NSManaged public var current_pomo: NSNumber
    @NSManaged public var current_pomo_elapsed_time: NSNumber
    @NSManaged public var desc: String
    @NSManaged public var expected_pomo: NSNumber
    @NSManaged public var interruptions: NSNumber
    @NSManaged public var name: String
    @NSManaged public var status: NSNumber

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?){
        super.init(entity: entity, insertIntoManagedObjectContext:context)
    }

}


