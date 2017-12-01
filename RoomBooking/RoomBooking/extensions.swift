//
//  extensions.swift
//  RoomBooking
//
//  Created by Fareed Quraishi on 2017-11-17.
//  Copyright © 2017 Treefrog Inc. All rights reserved.
//

import Foundation
import UIKit

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

extension UIViewController {
    
    func slackRequest(message: String){
        
        if let url = URL(string: "https://hooks.slack.com/services/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"){
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let params = ["text" : "\(message)"] as Dictionary<String, String>
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("Error")
            }
            let session = URLSession.shared
            session.dataTask(with: request as URLRequest, completionHandler: { (returnData, response, error) -> Void in
                //print(response)
            }).resume()
        }
    }
}
