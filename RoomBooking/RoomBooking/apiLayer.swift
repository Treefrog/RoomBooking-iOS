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
        let data = [[["Name":"Support Schedule", "Time":["Start":"11:00","End":"13:00"], "Attendees":"Russell\nGuest"],["Name":"Facilities Details", "Time":["Start":"13:00","End":"13:30"], "Attendees":""],["Name":"E-Commerice via Skype", "Time":["Start":"15:30","End":"17:00"], "Attendees":""]],[["Name":"ZPod", "Time":["Start":"14:00","End":"15:00"], "Attendees":""]]]
        
        let todaysEvents = setEvents(inputData: data[0])
        let upcommingEvents = setEvents(inputData: data[1])
        
        var returnedEvents = [[Event]]()
        returnedEvents.append(todaysEvents)
        returnedEvents.append(upcommingEvents)
        
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
            
            let anEvent = Event(name: givenName, start: givenStart, end: givenEnd, attendies: givenAttendies)
            
            returnEvents.append(anEvent)
        }
        return returnEvents
    }
}
