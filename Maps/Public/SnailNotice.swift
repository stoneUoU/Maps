//
//  SnailNotice.swift
//  Centers
//
//  Created by test on 2017/9/30.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit

protocol Notifier {
    associatedtype Notification: RawRepresentable
    
}

extension Notifier where Notification.RawValue == String {
    
    static func nameFor(notification: Notification) -> String {
        
        return "\(notification.rawValue)"
    }
}

class SnailNotice: Notifier {
    
    /// 发送通知听
    static func post(notification: Notification, object:AnyObject? = nil, passDicts:[String:String]? = nil) {
        
        let name = nameFor(notification: notification)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object,userInfo:passDicts)
    }
    
    /// 增加观察 - 接收通知
    static func add(observer: AnyObject, selector: Selector, notification: Notification, object:AnyObject? = nil) {
        
        let name = nameFor(notification: notification)
        NotificationCenter.default
            .addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
    }
    
    /// 移除观察 - 移除通知
    static func remove(observer: AnyObject, notification: Notification, object:AnyObject? = nil) {
        
        let name = nameFor(notification: notification)
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: object)
    }
}

// 定义的通知名字
extension SnailNotice {
    enum Notification: String {
        /// 开心
        case happy
        /// 伤心
        case sad
        /// 睡觉
        case sleep
        //Tab跳转
        case tabJump
        //监听网络变化
        case netChange
        //已经点击了启动页
        case startFinish
        //通知加载第一页数据   关注里的
        case loadFirstR
    }
}
