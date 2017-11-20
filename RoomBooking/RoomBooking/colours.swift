//
//  colours.swift
//  RoomBooking
//
//  Created by Fareed Quraishi on 2017-11-17.
//  Copyright © 2017 Treefrog Inc. All rights reserved.
//

import UIKit

struct colours {
    static let green1 = UIColor.init(netHex: 0x84BF41)
    static let green2 = UIColor.init(netHex: 0x9FCA6B)
    static let green3 = UIColor.init(netHex: 0xB3D382)
    static let green4 = UIColor.init(netHex: 0xDDEBC4)
    static let red1 = UIColor.red
    static let red2 = UIColor.init(netHex: 0xff6666)
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
