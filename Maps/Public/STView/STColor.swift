//
//  STColor.swift
//  Maps
//
//  Created by test on 2018/1/10.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit

func STColor(startColor: UIColor, endColor: UIColor, decimal: CGFloat) -> UIColor {
    var startR: CGFloat = 0, startG: CGFloat = 0, startB: CGFloat = 0, startA: CGFloat = 0
    startColor.getRed(&startR, green: &startG, blue: &startB, alpha: &startA)
    var endR: CGFloat = 0, endG: CGFloat = 0, endB: CGFloat = 0, endA: CGFloat = 0
    endColor.getRed(&endR, green: &endG, blue: &endB, alpha: &endA)
    let resultR = startR + (endR - startR) * decimal
    let resultG = startG + (endG - startG) * decimal
    let resultB = startB + (endB - startB) * decimal
    let resultA = startA + (endA - startA) * decimal
    return UIColor(red: resultR, green: resultG, blue: resultB, alpha: resultA)
}
