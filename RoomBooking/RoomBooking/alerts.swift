//
//  alerts.swift
//  RoomBooking
//
//  Created by Fareed Quraishi on 2017-11-20.
//  Copyright © 2017 Treefrog Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    private func alert(_ title: String, message: String) {
        dispatchMain {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) {
                (a:UIAlertAction) -> Void in
            }
            alert.addAction(action)
            self.present(alert, animated: true) { }
        }
    }
    
    private func alert(_ title: String, message: String, action:@escaping ()->()) {
        dispatchMain {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) {
                (a:UIAlertAction) -> Void in
                action()
            }
            alert.addAction(action)
            self.present(alert, animated: true) {
            }
        }
    }
    
    private func alert(_ title: String, message: String, okay:@escaping () -> (), cancel:@escaping ()->()) {
        dispatchMain {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) {
                (a:UIAlertAction) -> Void in
                okay()
            }
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
                (a:UIAlertAction) -> Void in
                cancel()
            }
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true) { }
        }
    }
    
    func alertImproptuBookingFailed() {
        alert("Double Booking", message: "This room is currently in use or will be in use.")
    }
    
    func alertRoomInUse() {
        alert("The room is currently in use.", message: "")
    }
}
