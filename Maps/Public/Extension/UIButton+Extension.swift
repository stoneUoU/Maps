//
//  UIButton+Extension.swift
//  Centers
//
//  Created by test on 2017/9/29.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
private var key: Void?
//MARK: ------扩展button
extension UIButton {

    //未UIbutton添加一个存储属性，便于传参
    var strBtn: String? {
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    enum HHButtonEdgeInsetsStyle: Int {
        case top = 1 //image在上，lebel在下
        case left    //image在左，lebel在右
        case bottom  //image在下，lebel在上
        case right   //image在右，lebel在左
    }

    func layoutButtonWithEdgesInsetsStyleWithSpace(_ style : HHButtonEdgeInsetsStyle, space : CGFloat) {
        //首先得到imageView和titleLabel的宽高
        let imageWith = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        var labelWith : CGFloat = 0
        var labelHeight : CGFloat = 0
        if kIOS8 == 1 {
            //由于ios8中titleLabel的size是0，用下面的这种设置
            labelWith = (self.titleLabel?.intrinsicContentSize.width)!
            labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        }else{
            labelWith = (self.titleLabel?.frame.size.width)!
            labelHeight = (self.titleLabel?.frame.size.height)!
        }
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - space / 2, 0, 0, -labelWith)
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith!, -imageHeight! - space / 2, 0)
        case .left:
            imageEdgeInsets = UIEdgeInsetsMake(0, -space / 2, 0, space / 2)
            labelEdgeInsets = UIEdgeInsetsMake(0, space / 2, 0, -space / 2)
        case .bottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight - space / 2, -labelWith)
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight! - space / 2, -imageWith!, 0, 0)
        default:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWith + space / 2, 0, -labelWith - space / 2)
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith! - space / 2, 0, imageWith! + space / 2)
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}
//public extension UIButton {
//    private struct cs_associatedKeys {
//        static var accpetEventInterval = "cs_acceptEventInterval"
//        static var acceptEventTime = "cs_acceptEventTime"
//    }
//    /**
//     重复点击的时间间隔--自己手动随意设置
//     利用运行时机制 将accpetEventInterval值修改
//     */
//    var cs_accpetEventInterval: TimeInterval {
//        get {
//            if let accpetEventInterval = objc_getAssociatedObject(self, &cs_associatedKeys.accpetEventInterval) as? TimeInterval {
//                return accpetEventInterval
//            }
//            return 1.0
//        }
//        set {
//            objc_setAssociatedObject(self, &cs_associatedKeys.accpetEventInterval, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    /**
//     重复点击的时间间隔--自己手动随意设置
//     利用运行时机制 将acceptEventTime值修改
//     */
//    var cs_acceptEventTime : TimeInterval {
//        get {
//            if let acceptEventTime = objc_getAssociatedObject(self, &cs_associatedKeys.acceptEventTime) as? TimeInterval {
//                return acceptEventTime
//            }
//            return 1.0
//        }
//        set {
//            objc_setAssociatedObject(self, &cs_associatedKeys.acceptEventTime, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    /**
//     重写初始化方法,在这个方法中实现在运行时方法替换
//     */
//    override open class func initialize() {
//        let changeBefore: Method = class_getInstanceMethod(self, #selector(UIButton.sendAction(_:to:for:)))
//        let changeAfter: Method = class_getInstanceMethod(self, #selector(UIButton.cs_sendAction(action:to:for:)))
//        method_exchangeImplementations(changeBefore, changeAfter)
//    }
//    /**
//     在这个方法中判断接收到当前事件的时间间隔是否满足我们所设定的间隔,会一直循环调用到满足才会return
//     */
//    func cs_sendAction(action: Selector, to target: AnyObject?, for event: UIEvent?) {
//        if NSDate().timeIntervalSince1970 - self.cs_acceptEventTime < self.cs_accpetEventInterval {
//            return
//        }
//        if self.cs_accpetEventInterval > 0 {
//            self.cs_acceptEventTime = NSDate().timeIntervalSince1970
//        }
//        self.cs_sendAction(action: action, to: target, for: event)
//    }
//}

