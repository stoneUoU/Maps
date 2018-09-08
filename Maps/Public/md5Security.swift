//
//  md5Security.swift
//  Gfoods
//
//  Created by 林磊 on 2017/8/25.
//  Copyright © 2017年 com.youlu. All rights reserved.

//md5加密
import Foundation

extension Int
{
    func hexedString() -> String
    {
        return NSString(format:"%02x", self) as String
    }
}

extension NSData
{
    func hexedString() -> String
    {
        var string = String()
        let unsafePointer = bytes.assumingMemoryBound(to: UInt8.self)
        for i in UnsafeBufferPointer<UInt8>(start:unsafePointer, count: length)
        {
            string += Int(i).hexedString()
        }
        return string
    }
    func MD5() -> NSData
    {
        let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))!
        let unsafePointer = result.mutableBytes.assumingMemoryBound(to: UInt8.self)
        CC_MD5(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(unsafePointer))
        return NSData(data: result as Data)
    }
}

extension String
{
    func MD5() -> String
    {
        let data = (self as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        return data.MD5().hexedString()
    }
}


//使用说明：

//self.user_name.text?.trimmingCharacters(in: .whitespaces).MD5().MD5().MD5()

