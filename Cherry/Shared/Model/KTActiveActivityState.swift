//
//  KTActiveActivityState.swift
//  Cherry
//
//  Created by Kenny Tang on 2/22/15.
//
//

class KTActiveActivityState {

    var activityID:String
    var activityName:String
    var status:Int
    var currentPomo:Int
    var elapsedSecs:Int

    init(id: String, name:String, status:Int, currentPomo:Int, elapsed:Int) {
        self.activityID = id
        self.activityName = name
        self.status = status
        self.currentPomo = currentPomo
        self.elapsedSecs = elapsed
    }

}
