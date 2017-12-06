//
//  UIFont+Extension.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

extension UIFont{
    class func UiFontSize(size:CGFloat) -> UIFont {
        if(UIScreen.main.bounds.height <= 667){  // 6 6S 7
            return UIFont.systemFont(ofSize: size)
        }else{
            return UIFont.systemFont(ofSize: size*1.5)
        }
    }
    class func UiBoldFontSize(size:CGFloat) -> UIFont {
        if(UIScreen.main.bounds.height <= 667){  // 6 6S 7
            return UIFont.boldSystemFont(ofSize: size)
        }else{
            return UIFont.boldSystemFont(ofSize: size*1.5)
        }
    }
    
}


