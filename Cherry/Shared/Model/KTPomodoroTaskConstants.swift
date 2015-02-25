//
//  KTPomodoroTaskConstants.swift
//  Cherry
//
//  Created by Kenny Tang on 2/22/15.
//
//

import Foundation

struct Constants {

    enum KTPomodoroActivityStatus: Int {
        case InProgress = 0, Stopped, Completed
    }

    enum KTPomodoroStartActivityError: Int {
        case OtherActivityActive
    }

}

