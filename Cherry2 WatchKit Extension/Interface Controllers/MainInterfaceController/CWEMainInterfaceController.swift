//
//  CWEMainInterfaceController.swift
//  Cherry2
//
//  Created by Kenny Tang on 6/9/15.
//  Copyright © 2015 Kenny Tang. All rights reserved.
//

import WatchKit
import Foundation


class CWEMainInterfaceController: WKInterfaceController {

    @IBOutlet var categoriesPicker:WKInterfacePicker!
    @IBOutlet var activitiesTable:WKInterfaceTable!
    var activitiesDict = [Int:[CHActivityModel]]()
    var selectedCategoryIndex:Int = -1

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        setUpTable()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    // MARK: set up table
    func setUpTable() {

        do {
            // categories
            CHCCoreDataStack.sharedInstance.seedData()

            var pickerItems = [WKPickerItem]()
            let categories = try CHCCoreDataStack.sharedInstance.retrieveCategories()
            for category in categories {
                if let title = category.name {
                    let categoryItem = WKPickerItem()
                    categoryItem.title = title
                    pickerItems.append(categoryItem)
                }
            }
            self.categoriesPicker.setItems(pickerItems)

            // activities
            var categoryIndex = 0
            for category in categories {
                let activitiesInCategory = try CHCCoreDataStack.sharedInstance.retriveActivities(category.categoryID)
                self.activitiesDict[categoryIndex] = activitiesInCategory
                categoryIndex++
            }


        } catch {
            print("Error in setUpTable: %@", error)
        }


    }

    // MARK: action methods of categories picker

    @IBAction func handleCategoriesPickerActionindexInt(value: Int) {
        print("selected int: %f", value)

        if (value != self.selectedCategoryIndex) {
            self.clearTableRows()
            if let activitiesInCategory = self.activitiesDict[value] {
                self.activitiesTable.insertRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, activitiesInCategory.count)), withRowType: "CWEMainInterfaceRowController")

                var i = 0
                for activity in activitiesInCategory {


                    if let rowController = self.activitiesTable.rowControllerAtIndex(i) as? CWEMainInterfaceRowController{
                        rowController.activityNameLabel!.setText(activity.name)
                    }
                    i++
                }
            }
//            WKInterfaceDevice.currentDevice().playHaptic(.Stop)

        }

        self.selectedCategoryIndex = value
    }

    // MARK: handleCategoriesPickerActionindexInt helper methods
    private func clearTableRows() {
        self.activitiesTable.removeRowsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, self.activitiesTable.numberOfRows)))

    }


}
