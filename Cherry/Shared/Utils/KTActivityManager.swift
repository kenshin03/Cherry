//
//  KTActivityManager.swift
//  Cherry
//
//  Created by Kenny Tang on 2/22/15.
//
//
import UIKit

protocol KTActivityManagerDelegate {
    func activityManager(manager:KTActivityManager?, activityDidUpdate model:KTPomodoroActivityModel?)

}

class KTActivityManager {

    // MARK: - Properties

    var activity:KTPomodoroActivityModel?
    var activityTimer:NSTimer?
    var breakTimer:NSTimer?
    var currentPomo:Int?
    var breakElapsed:Int?

    var delegate:KTActivityManagerDelegate?


    // MARK: - Public

    class var sharedInstance: KTActivityManager {
        struct Static {
            static let instance: KTActivityManager = KTActivityManager()
        }
        return Static.instance
    }

    func startActivity(activity:KTPomodoroActivityModel, error:NSErrorPointer) {

        if (self.hasOtherActiveActivityInSharedState(activity.activityID)) {
            error.memory =  NSError(domain:"com.corgitoergosum.net",
                code: Constants.KTPomodoroStartActivityError.OtherActivityActive.rawValue,
                userInfo: nil)
            return
        }

        // initialize internal variables
        self.intializeInternalState(activity)

        // start timer
        self.startActivityTimer()
    }

    func continueActivity(activity:KTPomodoroActivityModel) {
        self.activity = activity
        self.currentPomo = activity.current_pomo.integerValue
        self.updateSharedActiveActivityStateFromModel(activity)
        self.startActivityTimer()
    }

    func stopActivity() {
        self.activity?.status = Constants.KTPomodoroActivityStatus.Stopped.rawValue
        if let activity = self.activity {
            self.updateSharedActiveActivityStateFromModel(activity)
        }

        // save to disk
//        KTCoreDataStack.sharedInstance.saveContext()

        self.resetManagerInternalState()
    }


    // MARK: - Private
    // MARK: startActivity: helper methods

    func resetManagerInternalState() {
        self.activity = nil
        self.currentPomo = 0
        self.breakElapsed = 0
        self.invalidateTimers()
    }

    func startActivityTimer () {
        self.invalidateTimers()

        self.activityTimer = NSTimer(timeInterval: 1, target: self, selector: Selector("activityTimerFired"), userInfo: nil, repeats: true)

        self.scheduleTimerInRunLoop(self.activityTimer!)

    }

    func intializeInternalState(activity:KTPomodoroActivityModel) {
        self.currentPomo = 0;
        self.breakElapsed = 0;

        activity.current_pomo = 0;
        activity.current_pomo_elapsed_time = 0
        activity.status = Constants.KTPomodoroActivityStatus.InProgress.rawValue;
        self.activity = activity;

        self.updateSharedActiveActivityStateFromModel(activity)

    }

    func hasOtherActiveActivityInSharedState(ID:String) -> Bool {
        if let activity = self.activeActivityInSharedStorage() as KTActiveActivityState? {
            return activity.activityID == ID
        }

        return false
    }

    func activeActivityInSharedStorage() -> KTActiveActivityState? {
        if let activityData = KTSharedUserDefaults.sharedUserDefaults.objectForKey("ActiveActivity") as? NSData {

            if let activity = NSKeyedUnarchiver.unarchiveObjectWithData(activityData) as? KTActiveActivityState{
                return activity
            }
        }
        return nil
    }
    // ⌚️📱

    func updateSharedActiveActivityStateFromModel(activeActivity:KTPomodoroActivityModel) {

        var updatedActiveActivity:KTActiveActivityState

        if let sharedActivity = self.activeActivityInSharedStorage(){
            if (sharedActivity.activityID == activeActivity.activityID) {
                // update existing object
                updatedActiveActivity = sharedActivity
                updatedActiveActivity.currentPomo = activeActivity.current_pomo.integerValue
                updatedActiveActivity.status = activeActivity.status.integerValue
                updatedActiveActivity.elapsedSecs = activeActivity.current_pomo_elapsed_time.integerValue
            } else {
                updatedActiveActivity = self.createActiveActivityFromModel(activeActivity)
            }
        } else {
            //creaate new object the first time
            updatedActiveActivity = self.createActiveActivityFromModel(activeActivity)
        }

        if (updatedActiveActivity.status == Constants.KTPomodoroActivityStatus.Stopped.rawValue) {

            KTSharedUserDefaults.sharedUserDefaults.removeObjectForKey("ActiveActivity")

        } else {
            KTSharedUserDefaults.sharedUserDefaults.removeObjectForKey("ActiveActivity")
        }

        KTSharedUserDefaults.sharedUserDefaults.synchronize()

    }

    func createActiveActivityFromModel(activeActivity:KTPomodoroActivityModel) -> KTActiveActivityState {
        return KTActiveActivityState(id: activeActivity.activityID,
            name: activeActivity.name,
            status: activeActivity.status.integerValue,
            currentPomo: activeActivity.current_pomo.integerValue,
            elapsed: activeActivity.current_pomo_elapsed_time.integerValue)
    }

    func invalidateTimers() {
        self.activityTimer?.invalidate()
        self.breakTimer?.invalidate()
    }

    func scheduleTimerInRunLoop(timer:NSTimer) {
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)

    }

    // MARK - timers helper methods

    @objc func activityTimerFired() {
        // increment current pomo elapsed time
        var currentPomoElapsed = 0
        if let elapsed = self.activity?.current_pomo_elapsed_time.integerValue {
            currentPomoElapsed = elapsed + 1
            self.activity?.current_pomo_elapsed_time = currentPomoElapsed
        }

        self.delegate?.activityManager(self, activityDidUpdate: self.activity)

        if let activity = self.activity {
            self.updateSharedActiveActivityStateFromModel(activity)
        }

        if (currentPomoElapsed == KTSharedUserDefaults.pomoDuration*60) {
            // reached end of pomo
            self.handlePomoEnded()
        }
    }

    // Swift Gotchas
    @objc func breakTimerFired() {
        println("breakTimerFired not implemented")
//        self.breakElapsed++
//        if (self.breakElapsed < KTSharedUserDefaults.breakDuration*60) {
//            // continue break
//            // TODO: break
//        }
    }

    // MARK: activityTimerFired: helper methods
    func handlePomoEnded() {
        self.currentPomo!++
        self.activity?.current_pomo = self.currentPomo!
        if (self.activityHasMorePomo(self.activity)) {
            self.pauseActivityStartBreak()
        } else {
            self.completeActivityOnLastPomo()
        }
    }

    // MARK: handlePomoEnded helper methods
    func completeActivityOnLastPomo() {
        self.activity?.status = Constants.KTPomodoroActivityStatus.Completed.rawValue
        self.activity?.actual_pomo = self.currentPomo!

        // save to disk
        

        self.delegate?.activityManager(self, activityDidUpdate: self.activity)

        self.resetManagerInternalState()
    }


    func pauseActivityStartBreak() {
        self.activityTimer?.invalidate()
    }

    func startBreakTimer() {
        self.breakTimer?.invalidate()
        self.breakTimer = NSTimer(timeInterval: 1, target: self, selector: Selector("breakTimerFired"), userInfo: nil, repeats: true)
        self.scheduleTimerInRunLoop(self.breakTimer!)
    }


    func activityHasMorePomo(activity:KTPomodoroActivityModel?) -> Bool{
        if let activity = activity {
            let expectedPomo = activity.expected_pomo.integerValue - 1
            if let currentPomo = self.currentPomo {
                return expectedPomo > currentPomo
            }
        }
        return false
    }






}
