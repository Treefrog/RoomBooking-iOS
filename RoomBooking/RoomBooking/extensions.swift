//
//  extensions.swift
//  RoomBooking
//
//  Created by Fareed Quraishi on 2017-11-17.
//  Copyright © 2017 Treefrog Inc. All rights reserved.
//

import Foundation

func dispatchMain(closure: @escaping ()->()) {
    DispatchQueue.main.async {
        closure()
    }
}

extension Date {
    func toString() -> String {
        let tmpFormatter = DateFormatter()
        tmpFormatter.dateFormat = "h:mm"
        return tmpFormatter.string(from: self)
    }
    
    func toStringFromInput() -> String {
        let tmpFormatter = DateFormatter()
        tmpFormatter.dateFormat = "HH:mm"
        return tmpFormatter.string(from: self)
    }
}

extension String {
    func toDate(isClose:Bool = false) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: nil)
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        
        //Sets the date to today
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        var componentsGiven = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = componentsGiven.hour
        components.minute = componentsGiven.minute
        let newDate = gregorian.date(from: components)!
        
        return newDate
    }
}
