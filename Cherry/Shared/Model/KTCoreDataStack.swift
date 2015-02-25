//
//  KTCoreDataStack.swift
//  Cherry
//
//  Created by Kenny Tang on 2/23/15.

//
//

import Foundation
import CoreData

public class KTCoreDataStack {

    private struct KTCoreDataStackConstants {
        static let appGroupID = "group.com.corgitoergosum.KTPomodoro"
    }

    public class var sharedInstance:KTCoreDataStack {
        struct Singleton {
            static let instance = KTCoreDataStack()
        }
        Singleton.instance.seedData()
        return Singleton.instance
    }

    // MARK - helper methods
    public func createActivity(name:String, desc:String, pomos:Int) -> KTPomodoroActivityModel? {

        var newActivity = NSEntityDescription.insertNewObjectForEntityForName("KTPomodoroActivityModel", inManagedObjectContext: self.managedObjectContext!) as KTPomodoroActivityModel;
        newActivity.name = name
        newActivity.desc = desc
        newActivity.status = Constants.KTPomodoroActivityStatus.Stopped.rawValue
        newActivity.expected_pomo = pomos
        newActivity.actual_pomo = 0
        newActivity.created_time = NSDate()
        newActivity.activityID = NSUUID().UUIDString
        return newActivity
    }

    func seedData() {
        if (self.allActivities()?.count == 0) {

            var newActivity1 = NSEntityDescription.insertNewObjectForEntityForName("KTPomodoroActivityModel", inManagedObjectContext: self.managedObjectContext!) as KTPomodoroActivityModel;
            newActivity1.name = "Activity 1"
            newActivity1.desc = ""
            newActivity1.status = Constants.KTPomodoroActivityStatus.Stopped.rawValue
            newActivity1.expected_pomo = 1
            newActivity1.actual_pomo = 0
            newActivity1.created_time = NSDate()
            newActivity1.activityID = NSUUID().UUIDString

            var newActivity2 = NSEntityDescription.insertNewObjectForEntityForName("KTPomodoroActivityModel", inManagedObjectContext: self.managedObjectContext!) as KTPomodoroActivityModel;
            newActivity2.name = "Activity 2"
            newActivity2.desc = ""
            newActivity2.status = Constants.KTPomodoroActivityStatus.Stopped.rawValue
            newActivity2.expected_pomo = 1
            newActivity2.actual_pomo = 0
            newActivity2.created_time = NSDate()
            newActivity2.activityID = NSUUID().UUIDString

        }
    }

    public func deleteActivity(activity:KTPomodoroActivityModel) {
        self.managedObjectContext?.deleteObject(activity)
        self.saveContext()
    }

    public func allActivities() -> [KTPomodoroActivityModel]? {
        let request = NSFetchRequest(entityName: "KTPomodoroActivityModel")
        request.sortDescriptors = [
            NSSortDescriptor(key: "created_time", ascending: false),
            NSSortDescriptor(key: "status", ascending: true)
        ]
        return self.managedObjectContext?.executeFetchRequest(request, error: nil) as [KTPomodoroActivityModel]?
    }

    // MARK - Core Data methods

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cogitoergosum.Test2" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()

    /*
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("KTPomodoroActivityModel", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
        // Workaround of swift access modifier issue
        // http://stackoverflow.com/a/26796626/1445534

        // Check if we are running as test or not
        let environment = NSProcessInfo.processInfo().environment as [String : AnyObject]
        let isTest = (environment["XCInjectBundle"] as? String)?.pathExtension == "xctest"

        // Create the module name
        let moduleName = (isTest) ? "CherryTests" : "Cherry"

        // Create a new managed object model with updated entity class names
        var newEntities = [] as [NSEntityDescription]
        for (_, entity) in enumerate(managedObjectModel.entities) {
            let newEntity = entity.copy() as NSEntityDescription
            if (moduleName == "") {
                newEntity.managedObjectClassName = "\(entity.name)"
            } else {
                newEntity.managedObjectClassName = "\(moduleName).\(entity.name)"
            }
            newEntities.append(newEntity)
        }

        let newManagedObjectModel = NSManagedObjectModel()
        newManagedObjectModel.entities = newEntities
        
        return newManagedObjectModel
        }()
    */

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("KTPomodoroActivityModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(KTCoreDataStackConstants.appGroupID)?.URLByAppendingPathComponent("Cherry.sqlite")

        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: containerURL, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }

        return coordinator
        }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()

    // MARK: - Core Data Saving support

    public func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }


}

