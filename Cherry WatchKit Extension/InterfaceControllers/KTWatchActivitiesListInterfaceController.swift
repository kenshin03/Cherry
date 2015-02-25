//
//  KTWatchActivitiesListInterfaceController.swift
//  Cherry
//
//  Created by Kenny Tang on 2/24/15.
//
//

import WatchKit
import Foundation


class KTWatchActivitiesListInterfaceController: WKInterfaceController {

    var activitiesList:[KTPomodoroActivityModel]!
    @IBOutlet weak var table: WKInterfaceTable!


    // MARK: overrides
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.setUpTable()
    }

    override func handleUserActivity(userInfo: [NSObject : AnyObject]!) {
        if let userInfo = userInfo {
            if let activityType = userInfo["type"] as? String{
                if (activityType == "com.corgitoergosum.KTPomodoro.select_activity") {
                    self.handleUserActivitySelectActivity(userInfo)
                }
            }
        }
    }

    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if (segueIdentifier == "activityDetailsSegue") {
            return self.activitiesList[rowIndex]
        }
        return nil
    }

    // MARK: handleUserActivity helper methods

    private func handleUserActivitySelectActivity(userInfo:[NSObject:AnyObject]) {
        if let selectedActivityID = userInfo["activityID"] as? String {
            for activity in self.activitiesList {
                if (activity.activityID == selectedActivityID) {
                    self.pushControllerWithName("KTWatchActivityInterfaceController", context: activity)
                    break
                }
            }
        }
    }

    private func setUpTable() {
        var activitiesCount = 0
        if let activitiesList = KTCoreDataStack.sharedInstance.allActivities() as [KTPomodoroActivityModel]?{
            activitiesCount = activitiesList.count

//            // list rows count changed, rebuild entire table just in case
//            if (self.activitiesList?.count != activitiesList.count) {
                self.clearTableRows()

                self.createTableFromActivitiesList(activitiesList)

//            } else {
//                // just update rows
//                self.updateTableFromActivitiesList(activitiesList)
//
//            }

            // add "add activity" row at the end
//            if (self.table.numberOfRows > 0) {
                self.table.insertRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(activitiesCount, 1)), withRowType: "KTWatchAddActivityRowInterfaceController")
//            }


            // update rows data
            self.activitiesList = activitiesList
        }
    }

    // MARK: setUpTable helper methods

    private func clearTableRows() {
        self.table.removeRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, self.table.numberOfRows)))

    }

    private func updateTableFromActivitiesList(activitiesList:[KTPomodoroActivityModel]) {
        var i = 0
        for activity in activitiesList {
            if let rowInterfaceController = self.table.rowControllerAtIndex(i) as? KTWatchActivitiesRowInterfaceController{

                // ordering of row might have changed. set the status value and visibility accordingly
                if (activity.status == Constants.KTPomodoroActivityStatus.InProgress.rawValue) {
                    rowInterfaceController.activityStatusLabel?.setText("In Progress")
                    rowInterfaceController.activityStatusLabel?.setHidden(false)
                } else {
                    rowInterfaceController.activityStatusLabel?.setHidden(true)
                }
            }
            i++
        }

    }

    private func createTableFromActivitiesList(activitiesList:[KTPomodoroActivityModel]) {

        // insert the rows first
        self.table.insertRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, activitiesList.count)), withRowType: "KTWatchActivitiesRowInterfaceController")

        // populate the data of each row
        var cellAlpha:CGFloat = 1.0
        var i = 0
        for activity in activitiesList {

            if let rowInterfaceController = self.table.rowControllerAtIndex(i) as? KTWatchActivitiesRowInterfaceController{
                rowInterfaceController.activityNameLabel?.setText(activity.name)
                if (activity.status == Constants.KTPomodoroActivityStatus.InProgress.rawValue) {
                    rowInterfaceController.activityStatusLabel?.setText("In Progress")
                    rowInterfaceController.activityStatusLabel?.setHidden(false)
                }
                // UI: make the rows reduce opacity by row
                rowInterfaceController.activityRowGroup?.setAlpha(cellAlpha)

                // only show status label on top most activity
                if (i > 0) {
                    rowInterfaceController.activityStatusLabel?.setHidden(true)
                }

                // TODO: do something more efficient like using an asset?
                rowInterfaceController.activityRowGroup?.setCornerRadius(cellAlpha)

                // reduce opacity
                if (cellAlpha > 0.2) {
                    cellAlpha -= 0.2
                }
            }
            i++
        }
    }

}
