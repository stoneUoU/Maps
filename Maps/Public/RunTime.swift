//
//  RunTime.swift
//  Maps
//
//  Created by test on 2017/11/10.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit


//CenterVals(avatar: "/static_file/uploads/10006/5d362cdec45e11e7a1076c0b849ba396.png", sex: "0", tel: "15717914505", nick_name: "不屑的小坦克6", rest_day: "365", full_day: "0", user_integral: "0")
class BaseModel: NSObject, NSCoding {
    // 使用runtime属性前面必须加dynamic，并且是不可选类型，意思是允许动态更新属性
    dynamic var avatar:String = ""
    //sex:0男  1女
    dynamic var sex:String = ""
    dynamic var tel:String = ""
    dynamic var nick_name:String = ""
    //呱呱豆
    dynamic var rest_day:String = ""
    //收菜天数
    dynamic var full_day:String = ""
    dynamic var user_integral:String = ""

    override init() {

    }

    // 归档
    func encode(with aCoder: NSCoder) {
        var count: UInt32 = 0
        guard let ivars = class_copyIvarList(self.classForCoder, &count) else {
            return
        }
        for i in 0 ..< count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)

            let key = NSString.init(utf8String: name!) as! String

            if let value = self.value(forKey: key) {
                aCoder.encode(value, forKey: key)
            }
        }
        // 释放ivars
        free(ivars)
    }

    // 反归档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        var count: UInt32 = 0
        guard let ivars = class_copyIvarList(self.classForCoder, &count) else {
            return
        }
        for i in 0 ..< count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            let key = NSString.init(utf8String: name!) as! String
            if let value = aDecoder.decodeObject(forKey: key) {
                self.setValue(value, forKey: key)
            }
        }
        // 释放ivars
        free(ivars)
    }

}

