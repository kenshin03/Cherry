//
//  KTTimerFormatter.swift
//  Cherry
//
//  Created by Kenny Tang on 2/22/15.
//
//

import Foundation
import UIKit

class KTTimerFormatter {

    class func formatTimeIntToTwoDigitsString(time:Int) -> String {
        return (time>9) ? "\(time)" : "0\(time)"
    }

    class func formatPomoRemainingMinutes(totalRemainingSecs: Int) -> Int {
        let pomoSecs = KTSharedUserDefaults.pomoDuration*60 - totalRemainingSecs
        let displayMinutes = Int(floor(Double(pomoSecs)/60.0))
        return displayMinutes
    }

    class func formatPomoRemainingSecsInCurrentMinute(totalRemainingSecs: Int) -> Int {
        let pomoSecs = KTSharedUserDefaults.pomoDuration*60 - totalRemainingSecs
        let displayMinutes = Int(Double(pomoSecs)%60.0)
        return displayMinutes
    }
   
}
