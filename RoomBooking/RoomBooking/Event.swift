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
    var startString:String
    var endString:String
    var attendees:String
    var start:Date {
        get {
            return startString.toDate()
        }
    }
    var end:Date {
        get {
            return endString.toDate()
        }
    }
    
    init(name:String, start:String, end:String, attendees:String) {
        self.name = name
        self.startString = start
        self.endString = end
        self.attendees = attendees
    }
    
    func isActive(at:Date = Date()) -> Bool {
        if at > start && at < end {
            return true
        }
        return false
    }
    
    func isPast() -> Bool {
        if Date() >= end {
            return true
        }
        return false
    }
}

extension Event: Decodable {
    enum MyStructKeys: String, CodingKey {
        case name = "name"
        case startString = "startString"
        case endString = "endString"
        case attendees = "attendees"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let start: String = try container.decode(String.self, forKey: .startString)
        let end: String = try container.decode(String.self, forKey: .endString)
        let attendees: String = try container.decode(String.self, forKey: .attendees)
        
        self.init(name: name, start: start, end: end, attendees: attendees)
    }
}
