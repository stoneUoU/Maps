//
//  Device+Extension.swift
//  Maps
//
//  Created by test on 2017/10/26.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

extension UIDevice {
    static func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
}
