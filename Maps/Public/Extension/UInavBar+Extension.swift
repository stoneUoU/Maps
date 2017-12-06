//
//  UInavBar+Extension.swift
//  Maps
//
//  Created by test on 2017/10/21.
//  Copyright © 2017年 com.youlu. All rights reserved.
//
import Foundation
import UIKit

//MARK: 让backBarButtonItem  和 自己实现的返回函数 交换
extension UINavigationItem {
    override open class func initialize() {
        exchange(originMethod: #selector(getter: self.backBarButtonItem), with: #selector(unifiedBackBarButtonItem), classInstance: self)
    }
    
    func unifiedBackBarButtonItem() -> UIBarButtonItem? {
        return UIBarButtonItem(title: " ", style: .done, target: nil, action: nil)
    }
}

//MARK: 改变返回的图片
extension UINavigationBar {
    override open class func initialize() {
        exchange(originMethod: #selector(getter: self.backIndicatorImage), with: #selector(unifiedBackBarImage), classInstance: self)
    }
    
    func unifiedBackBarImage() -> UIImage? {
        return adjustImagePosition()!.withRenderingMode(.alwaysOriginal)
    }
}

////            adjustImagePosition()!.withRenderingMode(.alwaysOriginal)


// 调整图片的位置  不调整的话由于系统的返回按钮是带有文字(返回二字)图片的位置会有点偏
func adjustImagePosition() -> UIImage?{
    let image = #imageLiteral(resourceName: "topico03")
    UIGraphicsBeginImageContextWithOptions(CGSize(width: image.size.width+5, height: image.size.height), false, UIScreen.main.scale)
    image.draw(at: CGPoint(x: 5, y: 0))
    
    let finalImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return finalImage
}

//MARK: 交换两个方法的实现
func exchange(originMethod:Selector,with newMethod:Selector, classInstance: AnyClass) {
    let before : Method  = class_getInstanceMethod(classInstance, originMethod)
    
    let after : Method = class_getInstanceMethod(classInstance, newMethod)
    
    method_exchangeImplementations(before, after)
}




