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
//extension UIButton {
//    //防止按钮被连续点击，重复发送ajax请求
//    private struct AssociatedKeys {
//        static var xlx_defaultInterval:TimeInterval = 0
//        static var xlx_customInterval = "xlx_customInterval"
//        static var xlx_ignoreInterval = "xlx_ignoreInterval"
//    }
//    var customInterval: TimeInterval {
//        get {
//            let xlx_customInterval = objc_getAssociatedObject(self, &AssociatedKeys.xlx_customInterval)
//            if let time = xlx_customInterval {
//                return time as! TimeInterval
//            }else{
//                return AssociatedKeys.xlx_defaultInterval
//            }
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.xlx_customInterval,  newValue as TimeInterval ,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    var ignoreInterval: Bool {
//        get {
//            return (objc_getAssociatedObject(self, &AssociatedKeys.xlx_ignoreInterval) != nil)
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.xlx_ignoreInterval, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    override open class func initialize() {
//        if self == UIButton.self {
//            DispatchQueue.once(NSUUID().uuidString, block: {
//                let systemSel = #selector(UIButton.sendAction(_:to:for:))
//                let swizzSel = #selector(UIButton.mySendAction(_:to:for:))
//
//                let systemMethod = class_getInstanceMethod(self, systemSel)
//                let swizzMethod = class_getInstanceMethod(self, swizzSel)
//
//
//                let isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod))
//
//                if isAdd {
//                    class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
//                }else {
//                    method_exchangeImplementations(systemMethod, swizzMethod);
//                }
//            })
//        }
//    }
//
//    private dynamic func mySendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
//        if !ignoreInterval {
//            isUserInteractionEnabled = false
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+customInterval, execute: { [weak self] in
//                self?.isUserInteractionEnabled = true
//            })
//        }
//        mySendAction(action, to: target, for: event)
//    }
//}

