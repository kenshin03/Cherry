//
//  KTCoreDataStackTests.swift
//  Cherry
//
//  Created by Kenny Tang on 2/23/15.
//
//

import XCTest
import Cherry
import CoreData

class KTCoreDataStackTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
/*
    func testCreateActivity() {

        let activityName = "test"
        let activityDesc = "desc"
        let pomos = 3

        let activity = KTCoreDataStack.sharedInstance.createActivity(activityName, desc:activityDesc, pomos:pomos)
        XCTAssertNotNil(activity, "Activity is nil")
        XCTAssertTrue(activity?.name == activityName, "Activity name is incorrect")
        XCTAssertTrue(activity?.desc == activityDesc, "Activity desc is incorrect")
        XCTAssertTrue(activity?.expected_pomo == pomos, "Activity pomo is incorrect")

        KTCoreDataStack.sharedInstance.deleteActivity(activity!)

    }

    func testFetchActivities() {

        KTCoreDataStack.sharedInstance.createActivity("test2", desc:"desc2", pomos:1)
        KTCoreDataStack.sharedInstance.createActivity("test3", desc:"desc3", pomos:1)
        KTCoreDataStack.sharedInstance.createActivity("test4", desc:"desc4", pomos:1)

        if let activities = KTCoreDataStack.sharedInstance.allActivities(){
            XCTAssertTrue(activities.count == 3, "There should be 3 activities created, got \(activities.count)")
        }


    }

*/

}
