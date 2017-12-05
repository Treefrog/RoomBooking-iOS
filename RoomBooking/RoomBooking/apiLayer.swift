//
//  apiLayer.swift
//  RoomBooking
//
//  Created by Fareed Quraishi on 2017-11-17.
//  Copyright © 2017 Treefrog Inc. All rights reserved.
//

import Foundation

class APILayer {
    static let shared = APILayer()
    
    func getEvents() -> [[Event]] {
        let json = """
            [{
            "name": "Support Schedule",
            "startString": "11:00",
            "endString": "13:00",
            "attendees": "Russell Guests"
            },{
            "name": "Facilities Details",
            "startString": "13:00",
            "endString": "13:30",
            "attendees": ""
            },{
            "name": "E-Commerice via Skype",
            "startString": "15:30",
            "endString": "17:00",
            "attendees": ""
            },{
            "name": "ZPod",
            "startString": "14:00",
            "endString": "15:00",
            "attendees": ""
            }]
            """.data(using: .utf8)! // our native (JSON) data
        
        guard let myStructArray = try? JSONDecoder().decode([Event].self, from: json) else {
            return [[Event]]()
        }
        
        var returnedEvents = [[Event]]()
        returnedEvents.append(myStructArray)
        
        return returnedEvents
        
    }
    
    func setEvents(inputData:[[String:Any]]) -> [Event] {
        var returnEvents = [Event]()
        for anItem in inputData {
            guard let givenName = anItem["Name"] as? String,
                let givenTime = anItem["Time"] as? [String:String],
                let givenStart = givenTime["Start"],
                let givenEnd = givenTime["End"],
                let givenAttendies = anItem["Attendees"] as? String else {
                    return [Event]()
            }
            
            let anEvent = Event(name: givenName, start: givenStart, end: givenEnd, attendees: givenAttendies)
            
            returnEvents.append(anEvent)
        }
        return returnEvents
    }
}
