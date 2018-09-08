//
//  Color.swift
//  Maps
//
//  Created by test on 2018/1/4.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import Foundation
import UIKit

enum Color {
    static let normalColor = UIColor(hex: 0x108ee9)
    static let destructiveColor = UIColor(hex: 0xf4333c)
    static let grayColor = UIColor(hex: 0xa9a9a9)
}

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid red component")
        assert(blue >= 0 && blue <= 255, "Invalid red component")

        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }

    convenience init(hex: Int) {
        self.init(red: CGFloat((hex >> 16) & 0xff), green: CGFloat((hex >> 8) & 0xff), blue: CGFloat(hex & 0xff))
    }

    func colorWithHexString(_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.characters.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        return UIColor(red: red, green: green, blue: blue)
    }
}

