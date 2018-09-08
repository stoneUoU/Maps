//
//  SingleClass.swift
//  Maps
//
//  Created by test on 2017/12/18.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

class SingleClass: NSObject {
    //使用全局变量
    static let singleClass = SingleClass()
    //swift  结构体返回单例
    class func shareDefault()->SingleClass{
        struct single{
            static var singleDefault = SingleClass()
        }
        return single.singleDefault
    }
    private override init(){}
}
