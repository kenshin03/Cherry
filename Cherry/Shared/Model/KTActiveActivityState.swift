//
//  KTActiveActivityState.swift
//  Cherry
//
//  Created by Kenny Tang on 2/22/15.
//
//
import UIKit

class KTActiveActivityState: NSObject, NSCoding {

    var activityID:String = ""
    var activityName:String = ""
    var status:Int = 0
    var currentPomo:Int = 0
    var elapsedSecs:Int = 0

    init(id: String, name:String, status:Int, currentPomo:Int, elapsed:Int) {
        self.activityID = id
        self.activityName = name
        self.status = status
        self.currentPomo = currentPomo
        self.elapsedSecs = elapsed
    }

    required init(coder aDecoder: NSCoder) {
        activityID = aDecoder.decodeObjectForKey("activityID") as! String
        activityName = aDecoder.decodeObjectForKey("activityName") as! String
        status = aDecoder.decodeObjectForKey("status") as! Int
        currentPomo = aDecoder.decodeObjectForKey("currentPomo") as! Int
        elapsedSecs = aDecoder.decodeObjectForKey("elapsedSecs") as! Int
    }

     func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(activityID, forKey: "activityID")
        aCoder.encodeObject(activityName, forKey: "activityName")
        aCoder.encodeObject(status, forKey: "status")
        aCoder.encodeObject(currentPomo, forKey: "currentPomo")
        aCoder.encodeObject(elapsedSecs, forKey: "elapsedSecs")
    }

}
