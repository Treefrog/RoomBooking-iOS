//
//  event.swift
//  RoomBooking
//
//  Created by Fareed Quraishi on 2017-11-17.
//  Copyright © 2017 Treefrog Inc. All rights reserved.
//

import Foundation

struct Event {
    var name:String
    var start:Date
    var startString:String
    var end:Date
    var endString:String
    var attendies:String
    
    init(name:String, start:String, end:String, attendies:String) {
        self.name = name
        self.start = start.toDate()
        self.startString = self.start.toString()
        self.end = end.toDate()
        self.endString = self.end.toString()
        self.attendies = attendies
    }
    
    func isActive(at:Date = Date()) -> Bool {
        if at > start && at < end {
            return true
        }
        return false
    }
}
