//
//  KTWatchAddActivityInterfaceController.swift
//  Cherry
//
//  Created by Kenny Tang on 2/24/15.
//
//

import WatchKit
import Foundation


class KTWatchAddActivityInterfaceController: WKInterfaceController {

    var activityName:String?
    var expectedPomos:Int = 1
    @IBOutlet weak var expectedPomosLabel:WKInterfaceLabel?
    @IBOutlet weak var confirmButton:WKInterfaceButton?
    @IBOutlet weak var activityNameButton:WKInterfaceButton?

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    // MARK: Action Handlers
    @IBAction func enterActivityNameButtonTapped() {
        self.presentTextInputControllerWithSuggestions([
            "Watch Cat Videos",
            "Exercise",
            "Do some writing",
            "Practice the guitar",
            "Read a book",
            "Work"], allowedInputMode: WKTextInputMode.Plain, completion:{(selectedAnswers) -> Void  in
                if let activityName = selectedAnswers?[0] as? String {
                    self.activityName = activityName
                    self.activityNameButton!.setTitle(activityName)
                    self.confirmButton!.setEnabled(true)
                    self.confirmButton!.setHidden(false)
                }
        })
    }

    @IBAction func confirmButtonTapped() {
        if let name = self.activityName {
            KTCoreDataStack.sharedInstance.createActivity(name, desc: "", pomos: self.expectedPomos)
            KTCoreDataStack.sharedInstance.saveContext()
        }
        self.dismissController()
    }

    @IBAction func pomoSliderValueChanged(value:CGFloat) {
        self.expectedPomos = Int(floor(value))
        self.expectedPomosLabel!.setText("\(self.expectedPomos)")
    }

}
