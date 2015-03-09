//
//  KTWatchActivityDetailsInterfaceController.swift
//  Cherry
//
//  Created by Kenny Tang on 2/24/15.
//
//

import WatchKit
import Foundation

let kActivityDetailsInterfaceControllerStatusMessageOtherActiveActivity = "Another activity is already in-progress.";
let kActivityDetailsInterfaceControllerStatusMessageBreak = "Taking Break";


class KTWatchActivityDetailsInterfaceController: WKInterfaceController, KTActivityManagerDelegate {

    var activity:KTPomodoroActivityModel?
    var currentBackgroundImageString:String?
    @IBOutlet weak var activityNameLabel:WKInterfaceLabel?
    @IBOutlet weak var plannedPomoLabel:WKInterfaceLabel?
    @IBOutlet weak var remainingPomoLabel:WKInterfaceLabel?
    @IBOutlet weak var timeLabel:WKInterfaceLabel?
    @IBOutlet weak var timerRingInterfaceGroup:WKInterfaceGroup?
    @IBOutlet weak var statusMessageGroup:WKInterfaceGroup?
    @IBOutlet weak var statusMessage:WKInterfaceLabel?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let activity = context as? KTPomodoroActivityModel {
            self.initializeInterface(activity)
            self.activity = activity
            self.registerUserDefaultChanges()
            self.updateInterfaceWithActiveActivity()
            self.statusMessage!.setText("Another activity is already in progress")
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        self.unregisterUserDefaultChanges()
        KTCoreDataStack.sharedInstance.saveContext()
    }

    // MARK: awakeWithContext helper methods
    private func initializeInterface(activity:KTPomodoroActivityModel) {
        self.currentBackgroundImageString = ""
        self.activityNameLabel!.setText(activity.name)
        self.plannedPomoLabel!.setText("\(activity.expected_pomo)")
        self.remainingPomoLabel!.setText("\(activity.expected_pomo)")
        self.statusMessageGroup!.setHidden(true)
        self.clearAllMenuItems()
    }

    private func registerUserDefaultChanges() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userDefaultsUpdated"), name: NSUserDefaultsDidChangeNotification, object: nil)
    }

    private func updateInterfaceWithActiveActivity() {
        if (self.activity?.status == Constants.KTPomodoroActivityStatus.InProgress.rawValue) {
            if let activeActivity = KTActivityManager.sharedInstance.activity {
                if (activeActivity != self.activity) {
                    // activity was active but timer stopped. restart timer.
                    if let activeActivity = self.activity {
                        KTActivityManager.sharedInstance.continueActivity(activeActivity)
                    }
                }
            }
            KTActivityManager.sharedInstance.delegate = self
            self.addMenuItemWithItemIcon(WKMenuItemIcon.Block, title: "Interrupt", action: Selector("interruptActivity:"))
            self.addMenuItemWithItemIcon(WKMenuItemIcon.Decline, title: "Stop", action: Selector("stopActivity:"))

        } else {
            if (!KTActivityManager.sharedInstance.hasOtherActiveActivityInSharedState(self.activity!.activityID)) {

                self.addMenuItemWithItemIcon(WKMenuItemIcon.Play, title: "Start", action: Selector("startActivity:"))
                self.addMenuItemWithItemIcon(WKMenuItemIcon.Trash, title: "Delete", action: Selector("deleteActivity:"))

            } else {
                self.statusMessage?.setText(kActivityDetailsInterfaceControllerStatusMessageOtherActiveActivity)
                self.statusMessageGroup?.setHidden(false)
            }
        }
    }

    // MARK - didDeactivate helper methods
    private func unregisterUserDefaultChanges() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUserDefaultsDidChangeNotification, object: nil)
    }

    // MARK - registerUserDefaultChanges helper methods

    @objc func userDefaultsUpdated() {
        // TODO: handle the case when the defaults is updated while an activity is on-going
    }

    // MARK - Action Outlets
    func interruptActivity(id:AnyObject) {
        self.stopActivity(id)
        if let activity = self.activity {
            var interruptions = activity.interruptions.integerValue
            interruptions++
            self.activity?.interruptions = interruptions
        }
    }

    func startActivity(id:AnyObject) {
        var error:NSError?
        let manager = KTActivityManager.sharedInstance
        manager.delegate = self
        if let activity = self.activity {
            manager.startActivity(activity, error: &error)

            if (error == nil) {
                self.timeLabel!.setText("\(KTSharedUserDefaults.pomoDuration):00")
                self.clearAllMenuItems()
                self.addMenuItemWithItemIcon(WKMenuItemIcon.Block, title: "Interrupt", action: Selector("interruptActivity:"))
                self.addMenuItemWithItemIcon(WKMenuItemIcon.Decline, title: "Stop", action: Selector("stopActivity:"))
            }
        }
    }

    func stopActivity(id:AnyObject) {
        KTActivityManager.sharedInstance.stopActivity()
        self.resetMenuItemsTimeLabel()
        self.resetBackgroundImage()
    }

    func deleteActivity(id:AnyObject?) {
        if let activity = self.activity {
            self.timeLabel!.setText("00:00")
            KTActivityManager.sharedInstance.stopActivity()
            KTCoreDataStack.sharedInstance.deleteActivity(activity)
            KTCoreDataStack.sharedInstance.saveContext()
        }
        self.popController()
    }

    // MARK - taskCompleted helper methods
    private func resetBackgroundImage() {
        self.timerRingInterfaceGroup!.setBackgroundImageNamed("circles_background")
    }

    private func resetMenuItemsTimeLabel() {
        self.clearAllMenuItems()
        self.addMenuItemWithItemIcon(WKMenuItemIcon.Play, title: "Start", action: Selector("startActivity:"))
        self.addMenuItemWithItemIcon(WKMenuItemIcon.Trash, title: "Delete", action: Selector("deleteActivity:"))
        self.timeLabel!.setText("00:00")
    }

    private func shouldAutoDeleteCompletedTasks() -> Bool{
        return KTSharedUserDefaults.shouldAutoDeleteCompletedActivites
    }

    // MARK: KTActivityManagerDelegate method
    func activityManager(manager: KTActivityManager?, activityDidPauseForBreak elapsedBreakTime: Int) {

        let displayMinutes = Int(floor(Double(elapsedBreakTime)/60.0))
        let displaySecsString = Int(Double(elapsedBreakTime)%60.0)

        self.timeLabel!.setText("\(displayMinutes):\(displaySecsString)")
        self.statusMessage?.setText(kActivityDetailsInterfaceControllerStatusMessageBreak)
        self.statusMessageGroup?.setHidden(false)

    }

    func activityManager(manager: KTActivityManager?, activityDidUpdate model: KTPomodoroActivityModel?) {
        if let activity = model {
            self.updateTimerBackgroundImage(activity)
            self.statusMessageGroup?.setHidden(true)

            let displayMinutes = KTTimerFormatter.formatTimeIntToTwoDigitsString(KTTimerFormatter.formatPomoRemainingMinutes(activity.current_pomo_elapsed_time.integerValue))
            let displaySecsString = KTTimerFormatter.formatTimeIntToTwoDigitsString(KTTimerFormatter.formatPomoRemainingSecsInCurrentMinute(activity.current_pomo_elapsed_time.integerValue))
            self.timeLabel!.setText("\(displayMinutes):\(displaySecsString)")

            let remainingPomos = activity.expected_pomo.integerValue - activity.current_pomo.integerValue
            self.remainingPomoLabel!.setText("\(remainingPomos)")


            if activity.status == Constants.KTPomodoroActivityStatus.Completed.rawValue {
                self.activityCompleted()
            }
        }
    }

    // MARK: activityManager:activityDidUpdate helper methods

    private func activityCompleted() {
        self.resetMenuItemsTimeLabel()
        if (self.shouldAutoDeleteCompletedTasks()) {
            self.deleteActivity(nil)
        }
    }

    private func updateTimerBackgroundImage(activity:KTPomodoroActivityModel) {
        let elapsedSections = activity.current_pomo_elapsed_time.integerValue / ((KTSharedUserDefaults.pomoDuration*60)/12)
        var backgroundImageString:String;
        if (elapsedSections < 10) {
            backgroundImageString = "circles_0\(elapsedSections)"
        } else {
            backgroundImageString = "circles_\(elapsedSections)"
        }
        if backgroundImageString != self.currentBackgroundImageString {
            self.currentBackgroundImageString = backgroundImageString
            self.timerRingInterfaceGroup!.setBackgroundImageNamed(backgroundImageString)
        }
    }


}
