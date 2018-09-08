//
//  ModelConvert.swift
//  Maps
//
//  Created by test on 2018/1/10.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

import UIKit

class ModelConvert: NSObject {
    /// JSONString转换为字典
    ///
    /// - Parameter jsonString:
    /// - Returns:
    static func getDictFromJSONStr(jsonStr:String) ->NSDictionary{

        let jsonData:Data = jsonStr.data(using: .utf8)!

        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()


    }

    /**
     字典转换为JSONString

     - parameter dictionary: 字典参数

     - returns: JSONString
     */
    static func getJSONStrFromDict(dict:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dict)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dict, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String

    }
}
