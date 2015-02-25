//
//  KTSharedUserDefaults.swift
//  Cherry
//
//  Created by Kenny Tang on 2/22/15.
//
//

import Foundation

class KTSharedUserDefaults {

    class var sharedUserDefaults: NSUserDefaults {
        struct Static {
            static let instance: NSUserDefaults = NSUserDefaults()
        }
        return Static.instance
    }

    class var pomoDuration: Int {
        return (KTSharedUserDefaults.sharedUserDefaults.integerForKey("pomo_length")>0) ? KTSharedUserDefaults.sharedUserDefaults.integerForKey("pomo_length") : 25
    }

    class var breakDuration: Int {
        return (KTSharedUserDefaults.sharedUserDefaults.integerForKey("break_length")>0) ? KTSharedUserDefaults.sharedUserDefaults.integerForKey("break_length") : 25
    }

    class var shouldAutoDeleteCompletedActivites: Bool {
        return KTSharedUserDefaults.sharedUserDefaults.boolForKey("delete_completed_activities") ? KTSharedUserDefaults.sharedUserDefaults.boolForKey("delete_completed_activities") : true
    }

}