//
//  UIColor+Extension.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

extension UIColor{
    
    //    扩充构造函数，必须扩充便利构造函数，明确的调用 self.init（）
    convenience init(r:CGFloat,g: CGFloat,b:CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    class func colorWithCustom(_ r: CGFloat, g:CGFloat, b:CGFloat,alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    /// RGB颜色
    ///
    /// - Parameters:
    ///   - r: red  0-255
    ///   - g: green 0-255
    ///   - b: blue 0-255
    /// - Returns: UIColor
    class func RGB (_ r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor {
        return self.RGBA(r, g, b, 1)
    }
    
    class func RGBA (_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor{
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    class func colorWithHexString(hex:String) ->UIColor {
        
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }

        if (cString.characters.count != 6) {
            return UIColor.red
        }

        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)

        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)

        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    public func getRGBValue() -> (CGFloat ,CGFloat,CGFloat) {



        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        //        return (red * 255, green * 255, blue * 255)
        return (red , green , blue )

    }

    public class func randomColor() -> UIColor
    {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
}
