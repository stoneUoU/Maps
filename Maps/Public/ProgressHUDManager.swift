//
//  ProgressHUDManager.swift
//  Maps
//
//  Created by test on 2017/10/9.
//  Copyright © 2017年 com.youlu. All rights reserved.
//

import UIKit
import SVProgressHUD
class ProgressHUDManager {
    
    class func setBackgroundColor(_ color: UIColor) {
        SVProgressHUD.setBackgroundColor(color)
    }
    
    class func setForegroundColor(_ color: UIColor) {
        SVProgressHUD.setForegroundColor(color)
    }
    
    class func setSuccessImage(_ image: UIImage) {
        SVProgressHUD.setSuccessImage(image)
    }
    
    class func setErrorImage(_ image: UIImage) {
        SVProgressHUD.setErrorImage(image)
    }
    
    class func setFont(_ font: UIFont) {
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16))
    }
    
    class func showImage(_ image: UIImage, status: String) {
        SVProgressHUD.show(image, status: status)
    }
    
    class func show() {
        SVProgressHUD.show()
    }
    
    class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    class func showWithStatus(_ status: String) {
        SVProgressHUD.show(withStatus: status)
    }
    
    class func isVisible() -> Bool {
        return SVProgressHUD.isVisible()
    }
    
    class func showSuccessWithStatus(_ string: String) {
        SVProgressHUD.showSuccess(withStatus: string)
    }
}

//使用说明：

//    showProgressHUD()
//    ProgressHUDManager.dismiss()
//// MARK: - Private Method
//fileprivate func showProgressHUD() {
//    ProgressHUDManager.setBackgroundColor(UIColor.colorWithCustom(230, g: 230, b: 230))
//    view.backgroundColor = UIColor.white
//    if !ProgressHUDManager.isVisible() {
//        ProgressHUDManager.showWithStatus("正在加载...")
//    }
//
//}
